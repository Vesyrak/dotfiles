#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function zshUbuntu()
{
    print "Installing zsh"
    install zsh
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    print "Configuring ZSH"
    stow -t ~/ zsh
    confenable zsh 0
    print "Changing Shell"
    sudo chsh -s $(which zsh) $USER
    todo "Reload shell to see effects of new shell"
}

zshUbuntu
