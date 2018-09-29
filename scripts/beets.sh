#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function beetsArch() {
  print "Installing beets audio manager"
  stow -t ~/ beets
  confenable beets 0
}

function beetsUbuntu() {
  beetsArch
}

while getopts "ua" opt; do
  case $opt in
    a)
      beetsArch
      ;;
    u)
      beetsUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
