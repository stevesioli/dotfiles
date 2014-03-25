#!/usr/bin/env bash
cwd=pwd

if [ $(whoami) != "root" ]; then
	echo "ERROR: This script must be run as root!"
	exit 1
fi

###############################################################################
# Install Linux packages                                                     #
###############################################################################
packagesFile="packages-linux.txt"
apt-get update && apt-get upgrade
read -p "Do you want to install packages [yN]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	filecontent=( `cat $packagesFile `)

	for p in "${filecontent[@]}"
	do
		apt-get install -y $p
		if [ $? != 0 ]; then
			echo -e "\t\033[31mFAIL\033[0m"
		else
			echo -e "\t\033[32mSUCCESS\033[0m"
		fi
	done
fi

###############################################################################
# Macbuntu Theme                                                              #
###############################################################################
read -p "Do you want to install the Macbuntu theme [yN]? " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	wget https://downloads.sourceforge.net/project/macbuntu/macbuntu-10.10/v2.3/Macbuntu-10.10.tar.gz -O /tmp/Macbuntu-10.10.tar.gz
	tar xzvf /tmp/Macbuntu-10.10.tar.gz -C /tmp
	cd /tmp/Macbuntu-10.10/
	./install.sh
	cd $pwd
fi

cp home/.bash_profile ~/.profile
cp home/.functions ~
cp home/.inputrc ~
cp home/.gitconfig ~

source ~/.profile
