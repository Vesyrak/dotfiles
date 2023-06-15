locale="en_IE.UTF-8"
parameters=(
    "LANG"
    "LC_ALL"
    "LANGUAGE"
    "LC_NUMERIC"
    "LC_TIME"
    "LC_MONETARY"
    "LC_PAPER"
    "LC_NAME"
    "LC_ADDRESS"
    "LC_TELEPHONE"
    "LC_MEASUREMENT"
    "LC_IDENTIFICATION"
)

for parameter in ${parameters[@]}; do
    kwriteconfig5 --file plasma-localerc --group Formats --key $parameter $locale
    sed -i "s/export $parameter=.*/export $parameter=$locale/g" "/home/$USER/.config/plasma-localerc"
    sudo sed -i "s/export $parameter=.*/export $parameter=$locale/g" "/etc/default/locale"
    sudo update-locale $parameter=$locale
done
sudo locale-gen

# Disable logout confirmation
kwriteconfig5 --file ksmserverrc --group General --key confirmLogout --type bool false

# Login with empty session
kwriteconfig5 --file ksmserverrc --group General --key loginMode default

# Disable Splash
kwriteconfig5 --file ksplashrc --group KSplash --key Engine none
kwriteconfig5 --file ksplashrc --group KSplash --key Theme None

# Create Wallpaper Folders if they dont exist
mkdir -p ~/WallPapers/SDDM/
mkdir -p ~/WallPapers/Desktop/

sudo sed -i "s/background=.*/background=\/home\/$USER\/Wallpapers\/SDDM\/background.png/g" "/usr/share/sddm/themes/ubuntu-theme/theme.conf"
# Set Screen Locker Background
kwriteconfig5 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/$USER/Wallpapers/SDDM/background.png"

# Icons
ln -s  ~/.dotfiles/icons/user_icon.png ~/.face.icon
ln -sf  ~/.dotfiles/icons/user_icon.png ~/.face
