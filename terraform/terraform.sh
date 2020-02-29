#!/usr/bin/env bash
set -a
[ -f ../env ] && . ../env
set +a

terraform "$@"
