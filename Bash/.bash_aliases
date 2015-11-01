alias scilab='/bin/bash ~/scilab-5.5.2/bin/scilab'
alias filterwpjpg='feh --action1 "rm %f" --action2 "mv %f ../Wallpapers/."'
alias lmao='urxvt -depth 32 -bg rgba:3f00/3f00/3f00/1111'
alias ethrpi='sudo ip link set up enp0s25 && sudo ip addr add 169.254.0.111/24 dev enp0s25'
alias grep='grep --color=auto'
alias cast='sudo '
alias woodo='sh ~/.woodo.sh'
alias ls='ls --color=auto'
#alias rm='rm --color=auto'
alias overcast='sudo '
alias bitchplease='sudo $(history -p !-1)'
alias starteduroam='sudo wpa_supplicant -c/home/reinout/wpa_supplicant-eduroam -i wlp3s0 -B && sudo dhcpcd && ping -c 3 www.google.com'
alias startapwifi='sudo wpa_supplicant -c/home/reinout/wpa_supplicant-apwifi -i wlp3s0 -B && sudo dhcpcd && ping -c 3 www.google.com'
alias cod2='wine /data/cod/CoD2MP_s.exe'
alias searchspellbook='sudo pacmatic -Ss'
alias researchspell='sudo pacmatic -S'
alias brainwash='sudo pacmatic -Rns'
alias listchapters='ls'
alias sacrifice='sudo rm -rf'
alias vision='sudo updatedb && locate'
alias summon='sudo mount --target /mnt --source'
alias dispel='sudo umount /mnt'
alias alter='vim'
alias checkrecipe='man'
alias mesmerize='cmatrix'
alias transcend='sudo pacmatic -Syu'
alias library='ranger'
alias changepage='cd'
alias mindcontrol='su'
alias conjureportal='chromium'
alias brewery='monodevelop'
alias corrupt='chown' 
alias transmute='mv'
alias cleanse='/bin/bash'
alias reincarnate='reboot'
alias doppelganger='cp -r' 
alias etherealize='poweroff'
alias listspells='cat ~/.bash_aliases'
alias hypnotize='screenfetch'
alias researchscroll='yaourt'
alias ascend='yaourt -Syua'
alias allahackbar='poweroff'
translate () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xvjf $1 && cd $(basename "$1" .tar.bz2) ;;
			*.tar.gz) tar xvzf $1 && cd $(basename "$1" .tar.gz) ;;
			*.tar.xz) tar Jxvf $1 && cd $(basename "$1" .tar.xz) ;;
			*.bz2) bunzip2 $1 && cd $(basename "$1" /bz2) ;;
			*.rar) unrar x $1 && cd $(basename "$1" .rar) ;;
			*.gz) gunzip $1 && cd $(basename "$1" .gz) ;;
			*.tar) tar xvf $1 && cd $(basename "$1" .tar) ;;
			*.tbz2) tar xvjf $1 && cd $(basename "$1" .tbz2) ;;
			*.tgz) tar xvzf $1 && cd $(basename "$1" .tgz) ;;
			*.zip) unzip $1 && cd $(basename "$1" .zip) ;;
			*.Z) uncompress $1 && cd $(basename "$1" .Z) ;;
			*.7z) 7z x $1 && cd $(basename "$1" .7z) ;;
			*) echo "don't know how to translate '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid spell!"
	fi
}

