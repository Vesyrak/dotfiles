# =============================================================================
#                                   Functions
# =============================================================================
powerlevel9k_random_color(){
    printf "%03d" $[${RANDOM}%234+16] #random between 16-250
}

zsh_wifi_signal(){
    local signal=$(nmcli -t device wifi | grep '^*' | awk -F':' '{print $6}')
    local color="yellow"
    [[ $signal -gt 75 ]] && color="green"
    [[ $signal -lt 50 ]] && color="red"
    echo -n "%F{$color}\uf1eb" # \uf1eb is 
}

function set_title(){
    echo -ne "\033];$(hostname): $(pwd)\007"
}

# =============================================================================
#                                   Variables
# =============================================================================
# Common ENV variables
export TERM="xterm-256color"
export SHELL="/bin/zsh"
#export EDITOR="vim"

# Fix Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE


#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

# color formatting for man pages
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;36m'     # begin blink
export LESS_TERMCAP_so=$'\e[1;33;44m'  # begin reverse video
export LESS_TERMCAP_us=$'\e[1;37m'     # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

export MANPAGER='less -s -M -R +Gg'

export LS_OPTIONS='--color=auto'

# Common aliases
alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias ls="ls $LS_OPTIONS -hFtr"
alias ll="ls $LS_OPTIONS -lAhFtr"
alias ccat="pygmentize -O style=monokai -f 256 -g"
alias dig="dig +nocmd any +multiline +noall +answer"

disable -r time       # disable shell reserved word
alias time='time -p ' # -p for POSIX output

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed
#[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
#source ~/.zplug/init.zsh

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
    zplug "zplug/zplug", hook-build:"zplug --self-manage"
fi
source ~/.zplug/init.zsh

# zplug
#zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# oh-my-zsh
#zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh"

# Load theme
zplug "mafredri/zsh-async", from:github, use:async.zsh
#zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, from:github, at:next, as:theme
zplug romkatv/powerlevel10k, use:powerlevel10k.zsh-theme, from:github, as:theme

#zplug "gporrata/bklyn-zsh"

#zplug "mafredri/zsh-async", from:github, use:async.zsh

zplug "chrissicool/zsh-256color"

# Miscellaneous commands
zplug "zdharma/zsh-diff-so-fancy"

zplug "k4rthik/git-cal", as:command
zplug "junegunn/fzf", use:"shell/*.zsh"

# Enhanced cd
zplug "b4b4r07/enhancd", use:init.sh

# Bookmarks and jump
zplug "jocelynmallon/zshmarks"

# Enhanced dir list with git features
zplug "supercrabtree/k"

# Jump back to parent directory
zplug "tarrasch/zsh-bd"

# Simple zsh calculator
zplug "arzzen/calc.plugin.zsh"

# Directory colors
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin
zplug "pinelibg/dircolors-solarized-zsh"

#zplug "laggardkernel/zsh-thefuck", as:plugin
# ZSH history database
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
#zplug "larkery/zsh-histdb", use:sqlite-history.zsh, hook-load:"histdb-update-outcome"
zplug "larkery/zsh-histdb", use:"{sqlite-history,histdb-interactive}.zsh", hook-load:"histdb-update-outcome"

zplug "zdharma/fast-syntax-highlighting"

zplug "plugins/common-aliase",     from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/copydir",           from:oh-my-zsh
zplug "plugins/copyfile",          from:oh-my-zsh
zplug "plugins/cp",                from:oh-my-zsh
zplug "plugins/dircycle",          from:oh-my-zsh
zplug "plugins/encode64",          from:oh-my-zsh
zplug "plugins/extract",           from:oh-my-zsh
zplug "plugins/history",           from:oh-my-zsh
zplug "plugins/tmux",              from:oh-my-zsh
zplug "plugins/tmuxinator",        from:oh-my-zsh
zplug "plugins/urltools",          from:oh-my-zsh
zplug "plugins/web-search",        from:oh-my-zsh
zplug "plugins/z",                 from:oh-my-zsh
zplug "plugins/fancy-ctrl-z",      from:oh-my-zsh

zplug "plugins/archlinux",     from:oh-my-zsh, if:"(( $+commands[pacman] ))"
zplug "plugins/dnf",           from:oh-my-zsh, if:"(( $+commands[dnf] ))"
zplug "plugins/mock",          from:oh-my-zsh, if:"(( $+commands[mock] ))"

zplug "plugins/git",               from:oh-my-zsh, if:"(( $+commands[git] ))"
zplug "plugins/golang",            from:oh-my-zsh, if:"(( $+commands[go] ))"
zplug "plugins/svn",               from:oh-my-zsh, if:"(( $+commands[svn] ))"
zplug "plugins/node",              from:oh-my-zsh, if:"(( $+commands[node] ))"
zplug "plugins/npm",               from:oh-my-zsh, if:"(( $+commands[npm] ))"
zplug "plugins/bundler",           from:oh-my-zsh, if:"(( $+commands[bundler] ))"
zplug "plugins/gem",               from:oh-my-zsh, if:"(( $+commands[gem] ))"
zplug "plugins/rvm",               from:oh-my-zsh, if:"(( $+commands[rvm] ))"
zplug "plugins/pip",               from:oh-my-zsh, if:"(( $+commands[pip] ))"
zplug "plugins/sudo",              from:oh-my-zsh, if:"(( $+commands[sudo] ))"
zplug "plugins/gpg-agent",         from:oh-my-zsh, if:"(( $+commands[gpg-agent] ))"
zplug "plugins/systemd",           from:oh-my-zsh, if:"(( $+commands[systemctl] ))"
zplug "plugins/docker",            from:oh-my-zsh, if:"(( $+commands[docker] ))"
zplug "plugins/docker-compose",    from:oh-my-zsh, if:"(( $+commands[docker-compose] ))"
zplug "plugins/terraform",         from:oh-my-zsh, if:"(( $+commands[terraform] ))"
zplug "plugins/vagrant",           from:oh-my-zsh, if:"(( $+commands[vagrant] ))"

zplug "plugins/vi-mode",           from:oh-my-zsh

zplug "djui/alias-tips"
zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
# zsh-syntax-highlighting must be loaded after executing compinit command
# and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# =============================================================================
#                                   Options
# =============================================================================
autoload -Uz add-zsh-hook
#autoload -Uz compinit && compinit -u
#autoload -Uz url-quote-magic
#autoload -Uz vcs_info

# required for zsh-histdb
#autoload -Uz add-zsh-hook
#add-zsh-hook precmd histdb-update-outcome

#autoload -U add-zsh-hook
#add-zsh-hook precmd  theme_precmd

#zle -N self-insert url-quote-magic

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt auto_list
setopt auto_menu
setopt auto_pushd
setopt extended_history         # Also record time and duration of commands.
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
setopt hist_ignore_space        # Ignore commands that start with space.
#setopt hist_ignore_all_dups
#setopt hist_ignore_dups
#setopt hist_reduce_blanks
#setopt hist_save_no_dups
#setopt ignore_eof
setopt inc_append_history
setopt interactive_comments
setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt magic_equal_subst
setopt notify
setopt print_eight_bit
#setopt print_exit_value
setopt prompt_subst
setopt pushd_ignore_dups
#setopt rm_star_wait
setopt share_history            # Share history between multiple shells
setopt transient_rprompt

## Changing directories
#setopt auto_pushd
#setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
#setopt pushd_minus              # Reference stack entries with "-".
#
#setopt extended_glob


function history() {
	#rg --smart-case --colors 'path:fg:yellow' --vimgrep -o '[^;]*$' ~/.zsh_history
	#rg --smart-case --vimgrep -p -o '[^;]*$' ~/.zsh_history
    rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" --vimgrep -o '[^;]*$' ~/.zsh_history
}

# Watching other users
#WATCHFMT="%n %a %l from %m at %t."
watch=(notme)         # Report login/logout events for everybody except ourself.
LOGCHECK=60           # Time (seconds) between checks for login/logout activity.
REPORTTIME=5          # Display usage statistics for commands running > 5 sec.

# Key timeout and character sequences
KEYTIMEOUT=1
WORDCHARS='*?_-[]~=./&;!#$%^(){}<>'


# =============================================================================
#                                   Startup
# =============================================================================


[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
DIRCOLORS_SOLARIZED_ZSH_THEME="256dark"

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

if zplug check "larkery/zsh-histdb"; then
    if [ ! -f "$HOME/.histdb/zsh-history.db" ]; then
        echo "Import your old zsh history with github.com/drewis/go-histdbimport"
    fi

    #_zsh_autosuggest_strategy_histdb_top_here() {
    #    local query="select commands.argv from
    #history left join commands on history.command_id = commands.rowid
    #left join places on history.place_id = places.rowid
    #where places.dir LIKE '$(sql_escape $PWD)%'
    #and commands.argv LIKE '$(sql_escape $1)%'
    #group by commands.argv order by count(*) desc limit 1"
    #    suggestion=$(_histdb_query "$query")
    #}
    #ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

    #bindkey '^r' _histdb-isearch
fi

if zplug check "junegunn/fzf-bin"; then
    export FZF_DEFAULT_OPTS="--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5"
fi

if zplug check "zsh-users/zsh-history-substring-search"; then
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey "^[[1;5A" history-substring-search-up
    bindkey "^[[1;5B" history-substring-search-down
fi

if zplug check "zsh-users/zsh-syntax-highlighting"; then
    typeset -gA ZSH_HIGHLIGHT_STYLES ZSH_HIGHLIGHT_PATTERNS

    ZSH_HIGHLIGHT_STYLES[cursor]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=none
    ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=070
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=070
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
    ZSH_HIGHLIGHT_STYLES[assign]=none

    ## Override highlighter colors
    #ZSH_HIGHLIGHT_STYLES[default]=none
    #ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
    #ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
    #ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold
    #ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
    #ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
    #ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
    #ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
    #ZSH_HIGHLIGHT_STYLES[commandseparator]=none
    #ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
    #ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
    #ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
    #ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
    ##ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
    ##ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
    #ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=070
    #ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=070
    #ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    #ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
    #ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
    #ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
    #ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
    #ZSH_HIGHLIGHT_STYLES[assign]=none

	#ZSH_HIGHLIGHT_STYLES[path]='fg=underline'
    #ZSH_HIGHLIGHT_STYLES[default]='none'
    #ZSH_HIGHLIGHT_STYLES[cursor]='fg=yellow'
    #ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
    #ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
    #ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
    #ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
    #ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
    #ZSH_HIGHLIGHT_STYLES[command]='fg=cyan'
    #ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
    #ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
    #ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
    #ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
    #ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey,underline'
    #ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=white'
    #ZSH_HIGHLIGHT_STYLES[path_approx]='fg=white'
    #ZSH_HIGHLIGHT_STYLES[globbing]='none'
    #ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=green'
    #ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=blue,bold'
    #ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=blue,bold'
    #ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
    #ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta,bold'
    #ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=magenta,bold'
    #ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
    #ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
    #ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
    #ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
    #ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
    #ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
    #ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
    #ZSH_HIGHLIGHT_STYLES[assign]='none'

    ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
fi

if zplug check "zsh-users/zsh-autosuggestions"; then
    #ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=075'
    #ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=162'

fi

if zplug check "b4b4r07/enhancd"; then
    ENHANCD_FILTER="fzf:peco:percol"
    ENHANCD_COMMAND="c"
fi

if zplug check "b4b4r07/zsh-history-enhanced"; then
    ZSH_HISTORY_FILE="$HISTFILE"
    ZSH_HISTORY_FILTER="fzf:peco:percol"
    ZSH_HISTORY_KEYBIND_GET_BY_DIR="^r"
    ZSH_HISTORY_KEYBIND_GET_ALL="^r^a"
fi


if zplug check "bhilburn/powerlevel9k"; then
#if zplug check "romkatv/powerlevel10k"; then
    #DEFAULT_USER=$USER

    # Easily switch primary foreground/background colors
    #DEFAULT_FOREGROUND=038 DEFAULT_BACKGROUND=024 PROMPT_COLOR=038

    DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235 PROMPT_COLOR=173
    DEFAULT_FOREGROUND=198 DEFAULT_BACKGROUND=090 PROMPT_COLOR=173
    DEFAULT_FOREGROUND=235 DEFAULT_BACKGROUND=159 PROMPT_COLOR=173
    DEFAULT_FOREGROUND=123 DEFAULT_BACKGROUND=059 PROMPT_COLOR=183
    DEFAULT_FOREGROUND=159 DEFAULT_BACKGROUND=238 PROMPT_COLOR=173
    DEFAULT_FOREGROUND=159 DEFAULT_BACKGROUND=239 PROMPT_COLOR=172
    #DEFAULT_COLOR=$DEFAULT_FOREGROUND
    DEFAULT_COLOR="clear"

    POWERLEVEL9K_MODE="nerdfont-complete"
    POWERLEVEL9K_STATUS_VERBOSE=false
    POWERLEVEL9K_DIR_SHORTEN_LENGTH=1
    #POWERLEVEL9K_SHORTEN_STRATEGY="truncate_right"

    POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false

    POWERLEVEL9K_CONTEXT_ALWAYS_SHOW=true
    POWERLEVEL9K_CONTEXT_ALWAYS_SHOW_USER=false

    #POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"

    #POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

    #POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\ue0b0%f"
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\ue0b2%f"
    POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{232}\uE0BD%f"
    POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{232}\uE0BD%f"
    #POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{232}/%f"
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{232}/%f"
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{000}%f"
    #POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{000}／%f" # 
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{000}／%f" #
    #POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 3 ))}／%f"
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 3 ))}／%f"
    #POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$DEFAULT_FOREGROUND}\uE0B0%f"
    #POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$DEFAULT_FOREGROUND}\uE0B3%f"

    #POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR_ICON='▓▒░'
    #POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR_ICON='░▒▓'
    #POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='▓▒░'
    #POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='░▒▓'
    #POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\uE0BC%f"
    #POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\uE0BA%f"

    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR_ICON="\uE0B4"
    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR_ICON="\uE0B6"
#    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0BC\u200A\uE0BC"
#    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0BA"
    #POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0BC"
    #POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0BA"
    #POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\uE0BC%f"
    #POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\uE0BA%f"
#

    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

    POWERLEVEL9K_STATUS_VERBOSE=true
    POWERLEVEL9K_STATUS_CROSS=true
    POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{$PROMPT_COLOR}%f"
    POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{$PROMPT_COLOR}➜ %f"
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX_ICON="%F{$PROMPT_COLOR}⇢ ➜  %f"
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX_ICON="%F{$PROMPT_COLOR} ┄⇢ %f"

    # POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir_writable dir vcs)
    # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time ssh)

    #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir_writable dir_joined vcs)
    #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir_writable dir_joined vcs)
    #POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator exec_time background_jobs time)
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir dir_writable vcs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time time)

    POWERLEVEL9K_MODE='nerdfont-complete'

    POWERLEVEL9K_VCS_GIT_GITHUB=""
    POWERLEVEL9K_VCS_GIT_BITBUCKET=""
    POWERLEVEL9K_VCS_GIT_GITLAB=""
    POWERLEVEL9K_VCS_GIT=""

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND="010"

    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="011"

    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="012"
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="011"

    POWERLEVEL9K_VCS_SHORTEN_STRATEGY="truncate_middle"

    POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_HOME_FOREGROUND="158"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="158"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="red"
    POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="158"
    POWERLEVEL9K_DIR_ETC_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_ETC_FOREGROUND="158"
    POWERLEVEL9K_DIR_NOT_WRITABLE_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND="158"

    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="red"

    POWERLEVEL9K_STATUS_OK_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"

    #POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S \uf017}" #  Jun 15  09:32
    POWERLEVEL9K_TIME="\uF017" # 
    #POWERLEVEL9K_TIME_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_TIME_FOREGROUND="183"

    POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="183"
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1

    POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="123"

    POWERLEVEL9K_USER_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_USER_DEFAULT_FOREGROUND="cyan"
    POWERLEVEL9K_USER_SUDO_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_USER_SUDO_FOREGROUND="magenta"
    POWERLEVEL9K_USER_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_USER_ROOT_FOREGROUND="red"
    POWERLEVEL9K_USER_DEFAULT="\uF415" # 
    POWERLEVEL9K_USER_ROOT=$'\uFF03' # ＃

    POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"
    #POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="123"
    POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="123"
    POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND="123"
    POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND="123"
    POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="123"

    POWERLEVEL9K_HOST_LOCAL_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_HOST_LOCAL_FOREGROUND="cyan"
    POWERLEVEL9K_HOST_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"
    #POWERLEVEL9K_HOST_REMOTE_FOREGROUND="magenta"
    POWERLEVEL9K_HOST_LOCAL="\uF109 " # 
    POWERLEVEL9K_HOST_REMOTE="\uF489 "  # 

    POWERLEVEL9K_SSH="\uF489 "  # 
    #POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    POWERLEVEL9K_SSH_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_SSH_FOREGROUND="212"
    #POWERLEVEL9K_OS_ICON_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_OS_ICON_FOREGROUND="212"
    #POWERLEVEL9K_SHOW_CHANGESET=true
fi

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# =============================================================================
#                                 Completions
# =============================================================================
#zstyle ':completion:' completer _complete _match _approximate
#zstyle ':completion:' group-name ''
## Color completion for some items.
##zstyle ':completion:' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:' matcher-list 'm:{a-z}={A-Z}'
#zstyle ':completion:' use-cache true
#zstyle ':completion:' verbose yes
#zstyle ':completion:*:default' menu select=2
#zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
#zstyle ':completion:*:options' description 'yes'

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# case-insensitive (uppercase from lowercase) completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# process completion
#zstyle ':completion:*:processes' command 'ps -au$USER'
#zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# zstyle
zstyle ':completion:*' completer _expand _complete _ignored _approximate
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{yellow}%d%f%u'
#zstyle ':completion:*:*:git:*' script ~/.git-completion.sh

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
source ~/.purepower

