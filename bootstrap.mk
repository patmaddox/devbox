all: system0.git

.PHONY: sudo git system0.git

# Defaults to my private repo, but can override with
# https://github.com/patmaddox/system0.git
REPO := git@github.com:patmaddox/system0.git

# shouldn't need to check for dir, but for some reason this gets run even ater cloning
system0.git: $(HOME)/system0.git
$(HOME)/system0.git: git
	if [ ! -d $(.TARGET) ]; then git clone --bare $(REPO) $(.TARGET); fi

git: /usr/local/bin/git
/usr/local/bin/git:
	sudo pkg install -y git

sudo: /usr/local/bin/sudo
/usr/local/bin/sudo:
	su - root -c 'pkg install -y sudo'
