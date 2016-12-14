#!/bin/bash
## Run as a normal user:
## wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/ubuntu/.ubuntu_LTS_Setup.sh -P ~/; bash ~/.ubuntu_LTS_Setup.sh

## Tested on 14.04 and 16.04.

sudo apt-get update && sudo apt-get dist-upgrade -y

if [ -z "$(grep 'alias apt' ~/.bash_aliases)" ]; then
  echo "## my aliases" >> ~/.bash_aliases
  echo "alias aptu='sudo apt-get update && sudo apt-get dist-upgrade -y'" >> ~/.bash_aliases
  echo "alias aptc='sudo apt-get autoclean && sudo apt-get clean && sudo apt-get autoremove -y'" >> ~/.bash_aliases
  echo "alias apti='sudo apt-get install -y '" >> ~/.bash_aliases
fi

if [ -z "$(grep 'xterm-256color' ~/.bashrc)" ]; then
  echo 'if [ "$DISPLAY" ]; then' >> ~/.bashrc
  echo '  export TERM=xterm-256color' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
fi

ESSENTIALPKGS="curl wget git vim vim-gnome build-essential libssl-dev lftp httrack"

sudo apt-get install -y $ESSENTIALPKGS

## Properly add the Google Chrome repo, and install the beta:
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
## Check for this so we don't keep adding the same line on re-runs:
if [ -z "$(find /etc/apt/sources.list.d/ -name 'google-*')" ]; then
  sudo wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/ubuntu/google-chrome-beta.list -P /etc/apt/sources.list.d/
fi
sudo apt-get update
sudo apt-get install -y google-chrome-beta

## Retrieve git and vim settings:
curl https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.gitVimNORMALorROOT.sh | sh

if [ `which unity` ]; then
  wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/ubuntu/.unitySetup.sh -P ~/; bash ~/.unitySetup.sh
fi

## Only run gnome 3 setup if unity is not installed.
if [ ! `which unity` ] && [ `which gnome-shell` ]; then
  wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.gnome3Setup -P ~/; bash ~/.gnome3Setup
fi

## Configure kde if present (Kubuntu):
if [ `which startkde` ]; then
  curl https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/kdeSetup.sh | bash
fi

## Mate!
if [ `which mate-panel` ]; then
  curl https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.mateSetup.sh | bash
fi

## nvm:
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

## Haskell!
curl -sSL https://get.haskellstack.org/ | sh

## Powerline fonts:
powerline_install() {
  cd ~/powerline-fonts/
  git pull
  ~/powerline-fonts/install.sh
}

if [ -d ~/powerline-fonts/ ]; then
  powerline_install
else
  git clone https://github.com/powerline/fonts.git ~/powerline-fonts/
  powerline_install
fi
cd

## Haskell-vim-now!
curl -L https://git.io/haskell-vim-now > /tmp/haskell-vim-now.sh
bash /tmp/haskell-vim-now.sh

## Set vim as the default editor:
if [ -z "$(grep -r 'EDITOR' /etc/profile.d/ && grep -r 'EDITOR' /etc/profile)" ]; then
  if [ ! -e /etc/profile.d/vimDefault ]; then
    sudo sh -c 'echo >> /etc/profile.d/vimDefault'
    sudo sh -c 'echo "export EDITOR=vim" >> /etc/profile.d/vimDefault'
    sudo sh -c 'echo "export VISUAL=vim" >> /etc/profile.d/vimDefault'
    sudo sh -c 'echo >> /etc/profile.d/vimDefault'
  fi
fi

echo
echo "    .--. "
echo "   |o_o | "
echo "   |:_/ | "
echo "  //   \ \ "
echo " (|     | ) "
echo "/'\_   _/'\ "
echo "\___)=(___/ "
echo
echo "A reboot may be necessary."
echo

