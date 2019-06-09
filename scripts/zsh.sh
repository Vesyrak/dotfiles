#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function zshUbuntu()
{
    print "Installing zsh"
    install zsh
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    print "Configuring ZSH"
    stow -t ~/ zsh
    confenable zsh 0
    print "Changing Shell"
    sudo chsh -s $(which zsh) $USER
    todo "Reload shell to see effects of new shell"
}

zshUbuntu
