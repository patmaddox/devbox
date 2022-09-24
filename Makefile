all: emacs

# Packages may be better done with a meta package...
# but this gets me going quickly and is good for experimentation.
# Plus I don't have to maintain packages for pkg and brew.

.PHONY: emacs

emacs: /usr/local/bin/emacs

/usr/local/bin/emacs:
	sudo pkg install -y emacs-nox
