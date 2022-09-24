all: devbox.git

.PHONY: sudo git devbox.git

# Defaults to my private repo, but can override with
# https://github.com/patmaddox/devbox.git
REPO := git@github.com:patmaddox/devbox.git

# shouldn't need to check for dir, but for some reason this gets run even ater cloning
devbox.git: $(HOME)/devbox.git
$(HOME)/devbox.git: git
	if [ ! -d $(.TARGET) ]; then git clone --bare $(REPO) $(.TARGET); fi

git: /usr/local/bin/git
/usr/local/bin/git:
	sudo pkg install -y git

sudo: /usr/local/bin/sudo
/usr/local/bin/sudo:
	su - root -c 'pkg install -y sudo'
