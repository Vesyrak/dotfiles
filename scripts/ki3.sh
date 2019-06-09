#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function i3kubuntu()
{
  install i3
  print "Configuring i3"
  stow -t ~/ i3
  confenable i3 0
}

i3kubuntu
