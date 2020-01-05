#!/usr/bin/env bash
while ! [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  echo "Waiting for cloud-init to finish.."
  sleep 2
done
