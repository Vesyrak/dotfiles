#!/bin/bash

TODO=""
function print() {
  echo ":: $1"
}

function todo() {
  TODO+=":: $1\n"
}

function finish() {
  print "TODO"
  echo $TODO
}
