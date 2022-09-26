all: pkg emacs tailscale tmux check-services

# Packages may be better done with a meta package...
# but this gets me going quickly and is good for experimentation.
# Plus I don't have to maintain packages for pkg and brew.

.PHONY: pkg emacs tailscale tmux
.PHONY: test test-*
.PHONY: check-services

pkg: /usr/local/etc/pkg/repos/FreeBSD.conf
/usr/local/etc/pkg/repos/FreeBSD.conf:
	sudo mkdir -p /usr/local/etc/pkg/repos
	cat /etc/pkg/FreeBSD.conf | sed -e 's/quarterly/latest/' | sudo tee $(.TARGET) > /dev/null

emacs: /usr/local/bin/emacs cmake libvterm
/usr/local/bin/emacs:
	sudo pkg install -y emacs-nox

cmake: /usr/local/bin/cmake
/usr/local/bin/cmake:
	sudo pkg install -y cmake

libvterm: /usr/local/lib/libvterm.so
/usr/local/lib/libvterm.so:
	sudo pkg install -y devel/libvterm

tailscale: /usr/local/bin/tailscale
/usr/local/bin/tailscale:
	sudo pkg install -y tailscale
	@sudo sysrc tailscaled_enable="NO"

tmux: /usr/local/bin/tmux
/usr/local/bin/tmux:
	sudo pkg install -y tmux

test: test-emacs

test-emacs: emacs
	@emacs --batch --load .emacs.d/init.el --eval '(message "emacs OK")'

/etc: /etc/pf.conf /etc/ssh/sshd_config
	@sudo touch $(.TARGET)

/etc/pf.conf: dist$(.TARGET).in
	cat dist$(.TARGET).in | sed -e 's/<ext_if>/vtnet0/' | sudo tee $(.TARGET)
	pfctl -nf $(.TARGET)

/etc/ssh/sshd_config: dist$(.TARGET)
	sudo cp dist$(.TARGET) $(.TARGET)

check-services:
	@sysrc pf_enable
	@sysrc tailscaled_enable
