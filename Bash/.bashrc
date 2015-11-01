#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
source ~/.bash_aliases

PS1='[\u@\h \W]\$ '
[ -n "$XTERM_VERSION" ] && transset-df -a >/dev/null
export PS1="\[\e[00;36m\]\h\[\e[0m\]\[\e[00;37m\]-\[\e[0m\]\[\e[00;36m\]\u\[\e[0m\]\[\e[00;37m\]->\[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]\[\e[00;37m\]:\[\e[0m\]"


