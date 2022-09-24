all: pkg emacs tailscale check-services

# Packages may be better done with a meta package...
# but this gets me going quickly and is good for experimentation.
# Plus I don't have to maintain packages for pkg and brew.

.PHONY: pkg emacs
.PHONY: test test-*
.PHONY: check-services

pkg: /usr/local/etc/pkg/repos/FreeBSD.conf
/usr/local/etc/pkg/repos/FreeBSD.conf:
	sudo mkdir -p /usr/local/etc/pkg/repos
	cat /etc/pkg/FreeBSD.conf | sed -e 's/quarterly/latest/' | sudo tee $(.TARGET) > /dev/null

emacs: /usr/local/bin/emacs
/usr/local/bin/emacs:
	sudo pkg install -y emacs-nox

tailscale: /usr/local/bin/tailscale
/usr/local/bin/tailscale:
	sudo pkg install -y tailscale
	@sudo sysrc tailscaled_enable="NO"

test: test-emacs

test-emacs: emacs
	@emacs --batch --load .emacs.d/init.el --eval '(message "emacs OK")'

/etc/pf.conf: dist$(.TARGET).in
	cat dist$(.TARGET).in | sed -e 's/<ext_if>/vtnet0/' | sudo tee $(.TARGET)
	pfctl -nf $(.TARGET)

check-services:
	@sysrc pf_enable
	@sysrc tailscaled_enable
