#!/usr/bin/env bash
set -a
[ -f ./env ] && . ./env
set +a

packer build -on-error=ask -var-file packer-vars.json "$@"
