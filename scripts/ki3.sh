#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function i3kubuntu()
{
  install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake
  
  cd /tmp
  git clone https://www.github.com/Airblader/i3 i3-gaps
  cd i3-gaps

  autoreconf --force --install
  rm -rf build/
  mkdir -p build && cd build/

  ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make
  sudo make install
  print "Configuring i3"
  stow -t ~/ i3
  confenable i3 0
}

i3kubuntu
