function aur()
{
    print "Installing AUR"
    sudo pacman -Syu
    print "First installing development packages"
    sudo pacman -S --needed base-devel cower yajl  expac wget
    #If cower can't be installed via pacman (aka if the AUR repo isn't present)
    if !(which cower > /dev/null); then
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
        tar -xvf cower.tar.gz
        cd cower
        makepkg --skippgpcheck
        makepkg -sri
        cd ../
        rm cower/ -r
    fi
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar -xvf pacaur.tar.gz
    cd pacaur
    makepkg --skippgpcheck
    makepkg -sri
    cd ../
    rm pacaur -r
    print "AUR Installation Finished"
}
