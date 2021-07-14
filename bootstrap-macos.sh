#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" && pwd )"

echo "$DIR"

###############################################################################
# Homebrew                                                                    #
###############################################################################
which -s brew
if [[ $? != 0 ]]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Homebrew gathers anonymous aggregated user behavior analytics and reports these to Google Analytics. It is recommended that you choose to opt out
    # See https://github.com/Homebrew/brew/blob/master/docs/Analytics.md for the detail.
    brew analytics off
    brew tap homebrew/bundle
    cd bin/
    brew bundle
    cd ..
else
    echo "Homebrew already installed."
fi

###############################################################################
# OSX Defaults                                                                #
###############################################################################
read -p "Do you want to update MacOS defaults? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f ~/.macos ]; then
        mv ~/.macos ~/.macos.BAK
    fi
    ln -s "$DIR/home/.macos" ~/.macos

    source ~/.macos
fi

###############################################################################
# MacOS App Store installs                                                    #
###############################################################################
echo "Installing application for App Store..."
echo
if ! command -v mas &> /dev/null; then
    echo "'mas' not found. installing first..."
    echo
    brew install mas
fi

# Login to App Store (disabled for 10.13+)
# mas signin steve.m@sioli.com

# 441258766 Magnet
# 937984704 Amphetamine
# 497799835 XCode
for app_id in 441258766 937984704; do
  echo "installing ${app_id}..."
  echo
  if mas purchase "${app_id}" | grep -q "purchased"; then
    echo
    echo -e "\033[1;33m${app_id} already purchased. re-downloading..."
    echo
    mas install "${app_id}"
  fi
  echo
done

###############################################################################
# Enable dot files                                                            #
###############################################################################

if [[ ! -d $HOME/.dotfiles ]]; then
  echo "'~/.dotfiles directory not found. Creating it."

  mkdir -p $HOME/.dotfiles
fi

echo "Linking dot files..."

ln -s "$DIR/home/.bash_profile.MACOS" ~/.bash_profile
ln -s ~/.bash_profile ~/.profile
ln -s ~/.bash_profile ~/.bashrc
ln -s "$DIR/home/.inputrc" ~/.inputrc
ln -s "$DIR/home/.aliases" ~/.dotfiles/aliases
ln -s "$DIR/home/.aliases.MACOS" ~/.dotfiles/aliases.MACOS
ln -s "$DIR/home/.functions" ~/.dotfiles/functions
ln -s "$DIR/dev/.gitconfig" ~/.gitconfig
ln -s "$DIR/dev/.gitprompt" ~/.gitprompt

if [[ -f $DIR/dev/.editorconfig ]]; then
  read -p "Detected '.editorconfig' file. Do you wish to install it? (y/n) " -n 1
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter destination directory: "
    echo

    if [[ ! -z $REPLY ]]; then
      cp -f "$DIR/dev/.editorconfig" "$REPLY" > /dev/null 2>&1

      if [[ -f $REPLY/.editorconfig ]]; then
        echo ".editorconfig copied!"
      else
        echo "Failed to copy to provided directory.  Try copying it manually."
      fi
    else
      echo "No directory provided. File will not be copied!"
    fi
  fi
fi

source ~/.bash_profile
