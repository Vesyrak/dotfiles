#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function zshArch(){
  print "Installing zsh"
  pacaur -S oh-my-zsh-git zsh zsh-completions pkgfile
  print "Configuring ZSH"
  stow -t ~/ zsh
  confenable zsh 0
  sudo pkgfile --update
  print "Changing Shell"
  chsh -s /bin/zsh
  print "Reload Shell to see effects"
}

function zshUbuntu()
{
    print "Installing zsh"
    sudo apt install zsh
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    print "Configuring ZSH"
    stow -t ~/ zsh
    confenable zsh 0
    print "Changing Shell"
    sudo chsh -s $(which zsh) $USER
    todo "Reload shell to see effects of new shell"
}

while getopts "ua" opt; do
  case $opt in
    a)
      zshArch
      ;;
    u)
      zshUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
