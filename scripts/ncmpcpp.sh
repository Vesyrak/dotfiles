#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function ncmpcppArch(parameter) {
  print "Configuring ncmpcpp"
  stow -t ~/ ncmpcpp
  confenable ncmpcpp -1
}

function ncmpcppUbuntu(parameter) {
  ncmpcppArch
}

while getopts "ua" opt; do
  case $opt in
    a)
      ncmpcppArch
      ;;
    u)
      ncmpcppUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
