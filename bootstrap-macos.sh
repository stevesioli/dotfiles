#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

###############################################################################
# Homebrew                                                                    #
###############################################################################
which -s brew
if [[ $? != 0 ]]; then
	echo "Installing Homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap homebrew/bundle
	cd bin/
	brew bundle
	cd ..
fi

###############################################################################
# OSX Defaults                                                                #
###############################################################################
read -p "Do you want to update MacOS defaults? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	if [ -f ~/.macos ]; then
		mv ~/.macos ~/.macos.BAK
	fi
	ln -s "$DIR/home/.macos" ~/.macos

	source ~/.macos
fi

echo -e "Linking home files..."
ln -s "$DIR/home/.bash_profile.MACOS" ~/.bash_profile
ln -s "$DIR/home/.aliases.MACOS" ~/.aliases.MACOS
ln -s ~/.bash_profile ~/.profile
ln -s ~/.bash_profile ~/.bashrc
ln -s "$DIR/home/.aliases" ~/.aliases
ln -s "$DIR/home/.functions" ~/.functions
ln -s "$DIR/home/.inputrc" ~/.inputrc
ln -s "$DIR/home/.gitconfig" ~/.gitconfig
ln -s "$DIR/home/.gitprompt" ~/.gitprompt

source ~/.bash_profile

