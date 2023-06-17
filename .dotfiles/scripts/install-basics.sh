#!/bin/bash
#
os_type=`uname`

if  [ "$os_type" = "Darwin" ]; then
    brew install bat \
        btop \
        codespell \
        commitlint \
        direnv \
        exa \
        glow \
        ncdu \
        neovim \
        pipx \
        prettier \
        proselint \
        pyenv \
        reattach-to-user-namespace \
        ripgrep \
        stylua \
        tmuxinator \
        watch \
        wget \
        yadm

elif [ "$os_type" = "Linux" ]; then
    # Glow repo
    sudo mkdir -p /etc/apt/keyrings

    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
        | sudo tee /etc/apt/sources.list.d/charm.list

    sudo apt update
    sudo apt install -y \
        bat \
        btop \
        codespell \
        curl \
        direnv \
        exa \
        git \
        glow \
        gzip \
        ncdu \
        python3-pip \
        python3-proselint \
        python3-venv \
        ripgrep \
        tar \
        tmuxinator \
        unzip \
        wget
    sudo snap install node --classic
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat

    pip3 install --user pipx
    # Global
    sudo npm install -g @commitlint/cli @commitlint/config-conventional prettier @johnnymorganz/stylua-bin

else
    echo "${os_type} is not supported" >&2
    exit 1
fi
pipx_packages=(
    autoflake
    black
    bump2version
    flake8
    isort
    mypy
    ocdc
    poetry
    tox
)
for PKG in "${pipx_packages[@]}"; do
    pipx install $PKG
done
