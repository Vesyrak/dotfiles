#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function ncmpcppArch( ) {
  print "Configuring ncmpcpp"
  stow -t ~/ ncmpcpp
  confenable ncmpcpp -1
}

function ncmpcppUbuntu() {
  ncmpcppArch
}

function ncmpcppDiet() {
  ncmpcppArch
}

while getopts "uad" opt; do
  case $opt in
    a)
      ncmpcppArch
      ;;
    u)
      ncmpcppUbuntu
      ;;
    d)
      ncmpcppDiet
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
