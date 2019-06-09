#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function atomUbuntu() {
  print "Installing atom"
  snapstall "atom --classic"
  todo "Don't forget to configure atom!"
}

atomUbuntu
