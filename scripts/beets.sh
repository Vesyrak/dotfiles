#!/bin/bash
for f in ./scripts/core/*; do source $f; done


function beetsUbuntu() {
  print "Installing beets audio manager"
  stow -t ~/ beets
  confenable beets 0
}

beetsUbuntu
