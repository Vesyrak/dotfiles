#!/bin/bash
for f in ./scripts/core/*; do source $f; done

. scripts/beets.sh
function mpdArch() {
  print "Installing mpd"
  pacaur -S mpd mpdas mlocate screenfetch alsa-utils pulseaudio beets python2-discogs-client python-flask ncmpcpp split2flac mac python-pyacoustid gst-plugins-bad gst-libav gst-plugins-good gst-plugins-ugly gst-python python-requests
  pip install discogs-client
  pip3 install flask pyacoustid requests
  sudo wget https://raw.githubusercontent.com/ftrvxmtrx/split2flac/master/split2flac -P /usr/bin/
  print "Configuring mpd"
  stow -t ~/ mpd
  confenable mpd 0
  sudo setfacl -m "u:mpd:rwx" /drive
  sudo sed  '/\[Unit\]/a RequiresMountsFor=/drive/' /etc/systemd/system/multi-user.target.wants/mpd.service
  sudo cp /etc/systemd/system/multi-user.target.wants/mpd.service /usr/lib/systemd/user/
  systemctl --user enable mpd
  systemctl --user start mpd TODO
  sudo loginctl enable-linger $USER
  print "Installing PulseAudio Service."
  set-default-sink alsa_output.usb-Burr-Brown_from_TI_USB_Audio_DAC-00.analog-stereo
  confenable pulseService 1
  print "Configuring MPD Scribble"
  mkdir ~/.mpdscribble
  sudo cp /etc/mpdscribble.conf ~/.mpdscribble/
  sudo chown $USER:$USER ~/.mpdscribble/mpdscribble.conf
  sudo cp mpdscribble/mpdscribble.service /usr/lib/systemd/user/
  read -p "Please enter your Last.FM username: " name
  read -p "Please enter your Last.FM password: " passwd
  mdpwd=$(echo -n "$passwd" | md5sum | cut -d ' ' -f 1)
  sed -i 's/\(username =\).*/\1/' .mpdscribble/mpdscribble.conf
  sed -i 's/\(password =\).*/\1/' .mpdscribble/mpdscribble.conf
  sed -i '/^username =/ s/$/ '$name'/' ~/.mpdscribble/mpdscribble.conf
  sed -i '/^password =/ s/$/ '$mdpwd'/' ~/.mpdscribble/mpdscribble.conf
  sudo systemctl stop mpdscribble
  sudo systemctl disable mpdscribble
  systemctl --user enable mpdscribble.service
  systemctl --user start mpdscribble.service
  beetsArch
}

function mpdUbuntu() {
  print "Installing mpd"
  sudo apt install mpd mpg123 mpdscribble alsa-utils pulseaudio beets python-pip python3-pip ncmpcpp cuetools shntool gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly
  pip install discogs-client
  pip3 install flask pyacoustid requests
  sudo wget https://raw.githubusercontent.com/ftrvxmtrx/split2flac/master/split2flac -P /usr/bin/
  print "Configuring mpd"
  stow -t ~/ mpd
  confenable mpd 0
  sudo setfacl -m "u:mpd:rwx" /drive
  sudo sed  '/\[Unit\]/a RequiresMountsFor=/drive/' /etc/systemd/system/multi-user.target.wants/mpd.service
  sudo cp /etc/systemd/system/multi-user.target.wants/mpd.service /usr/lib/systemd/user/
  systemctl --user enable mpd
  systemctl --user start mpd TODO
  sudo loginctl enable-linger $USER
  print "Installing PulseAudio Service."
  set-default-sink alsa_output.usb-Burr-Brown_from_TI_USB_Audio_DAC-00.analog-stereo
  confenable pulseService 1
  print "Configuring MPD Scribble"
  mkdir ~/.mpdscribble
  sudo cp /etc/mpdscribble.conf ~/.mpdscribble/
  sudo chown $USER:$USER ~/.mpdscribble/mpdscribble.conf
  sudo cp mpdscribble/mpdscribble.service /usr/lib/systemd/user/
  read -p "Please enter your Last.FM username: " name
  read -p "Please enter your Last.FM password: " passwd
  mdpwd=$(echo -n "$passwd" | md5sum | cut -d ' ' -f 1)
  sed -i 's/\(username =\).*/\1/' .mpdscribble/mpdscribble.conf
  sed -i 's/\(password =\).*/\1/' .mpdscribble/mpdscribble.conf
  sed -i '/^username =/ s/$/ '$name'/' ~/.mpdscribble/mpdscribble.conf
  sed -i '/^password =/ s/$/ '$mdpwd'/' ~/.mpdscribble/mpdscribble.conf
  sudo systemctl stop mpdscribble
  sudo systemctl disable mpdscribble
  systemctl --user enable mpdscribble.service
  systemctl --user start mpdscribble.service
  beetsUbuntu
}

function mpdDiet() {
  print "Installing split2flac"
  sudo wget https://raw.githubusercontent.com/ftrvxmtrx/split2flac/master/split2flac -P /usr/bin/
  print "Configuring mpd"
  stow -t / mpd
  confenable mpd 0
  sudo setfacl -m "u:mpd:rwx" /drive
  print "Configuring MPD Scribble"
  mkdir ~/.mpdscribble
  sudo cp /etc/mpdscribble.conf ~/.mpdscribble/
  sudo chown $USER:$USER ~/.mpdscribble/mpdscribble.conf
  sudo cp mpdscribble/mpdscribble.service /usr/lib/systemd/user/
  read -p "Please enter your Last.FM username: " name
  read -p "Please enter your Last.FM password: " passwd
  mdpwd=$(echo -n "$passwd" | md5sum | cut -d ' ' -f 1)
  sed -i 's/\(username =\).*/\1/' .mpdscribble/mpdscribble.conf
  sed -i 's/\(password =\).*/\1/' .mpdscribble/mpdscribble.conf
  sed -i '/^username =/ s/$/ '$name'/' ~/.mpdscribble/mpdscribble.conf
  sed -i '/^password =/ s/$/ '$mdpwd'/' ~/.mpdscribble/mpdscribble.conf
  sudo systemctl stop mpdscribble
  sudo systemctl disable mpdscribble
  systemctl --user enable mpdscribble.service
  systemctl --user start mpdscribble.service
  beetsUbuntu
}

while getopts "ua" opt; do
  case $opt in
    a)
      mpdArch
      ;;
    u)
      mpdUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
