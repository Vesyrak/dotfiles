#!/bin/bash

function print() {
  echo ":: $@"
}

function todo() {
  TODO="$TODO:: $@\n"
  echo $TODO
  export TODO
  echo $TODO
}

function finish() {
  echo "shit"
  echo $TODO
  if [[ $TODO != "" ]]; then
    print "TODO"
    echo $TODO
  fi
}
