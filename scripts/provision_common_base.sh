#!/usr/bin/env bash
set -e

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y net-tools sysstat htop tmux git wget curl less \
    libnss-mdns tcpdump man iftop dnsutils ndisc6 avahi-daemon  \
    open-vm-tools zsh stow

sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo dpkg-reconfigure --frontend=noninteractive locales
sudo update-locale LANG=en_US.UTF-8
