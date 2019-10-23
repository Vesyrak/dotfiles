#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function sshUbuntu() {
  todo "Ssh setting is skipped in ubuntu"
  todo "To re-enable this, you need to re-check existing configuration"
}

sshUbuntu
