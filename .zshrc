# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
POWERLEVEL9K_INSTANT_PROMPT=quiet

alias python=python3

export PATH="$PATH:/Users/reinout/.local/bin" #Todo clean this up
export ZSH="$HOME/.zplug/repos/robbyrussell/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
HIST_STAMPS="dd/mm/yyyy"
export BAT_THEME="Dracula"

export EDITOR="nvim"

export LANG="en_IE.UTF-8"
export LC_ALL="en_IE.UTF-8"

export ZSH_THEME="powerlevel10k/powerlevel10k"
#export TMUX_POWERLINE_RCFILE="/Users/reinout/.config/tmux/tmux-powerlinerc"

# Python
export PYTHONDONTWRITEBYTECODE=1
#export PYTHONBREAKPOINT=ipdb.set_trace




zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Oh my zsh
plugins=(
    ag
    alias-finder
    aws
    copybuffer
    direnv
    docker
    docker-compose
    extract
    fd
    git
    gitfast
    history-substring-search
    pip
    poetry
    ripgrep
    rsync
    sudo
    tmux
    tmuxinator
    vi-mode
    wd
    zbell
)

source $ZSH/oh-my-zsh.sh

# Non-omz plugins
source ~/.zplug/init.zsh
zplug "djui/alias-tips"
zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "paulirish/git-open", as:plugin


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Options
# https://zsh.sourceforge.io/Doc/Release/Options.html
setopt APPEND_HISTORY
setopt AUTO_PARAM_SLASH
setopt AUTO_CD
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt MAGIC_EQUAL_SUBST
setopt NO_BEEP
setopt NO_HIST_BEEP
setopt NO_LIST_BEEP
setopt NOTIFY
setopt PRINT_EIGHT_BIT
setopt PATH_DIRS
setopt SHARE_HISTORY

# Keymap
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Aliases
alias vi="nvim"
alias vis="nvim -u NONE"
alias cp="cp -v"
alias rm="rm -v"
alias mv="mv -v"
alias ls="exa"
alias cat='bat --style=plain'
alias catcode='bat --style="numbers,changes"'
alias catdiff='bat --diff'
alias grep='rg'
alias weather='curl wttr.in/Brasschaat'
alias notes='cd ~/notes && vi'

alias docker_stop_all="docker stop $(docker ps -a -q)"
alias git-log="git log --pretty=oneline --graph --all"


# Work
source ~/.zshrc_work
# Rice
[ -f ~/.colors ] && source ~/.colors
# p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# zstyle
zstyle ':completion:*' completer _expand _complete _ignored _approximate
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{yellow}%d%f%u'
#zstyle ':completion:*:*:git:*' script ~/.git-completion.sh
#
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
    "m:{a-zA-Z}={A-Za-z}" \
    "r:|[._-]=* r:|=*" \
    "l:|=* r:|=*"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

#ZLE_RPROMPT_INDENT=0

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# vim: ft=zsh sw=4 sts=4 et

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
PATH="$HOME/.local/bin:$PATH"

#TODO: generalize/mace OS independent
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
