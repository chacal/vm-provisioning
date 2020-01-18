#!/usr/bin/env bash
set -e

NETRC=/root/.netrc
DOTFILES_REPO=https://github.com/chacal/dotfiles.git
JIHARTIK_DOTFILES=/home/jihartik/.dotfiles
ROOT_DOTFILES=/root/.dotfiles

# Clean up Github credentials on exit
trap '{ sudo rm -f ${NETRC}; exit 0; }' EXIT

sudo tee ${NETRC} >/dev/null <<EOF
machine github.com
login chacal
password ${GITHUB_ACCESS_TOKEN}

machine api.github.com
login chacal
password ${GITHUB_ACCESS_TOKEN}
EOF

# Setup .dotfiles for jihartik
sudo git clone ${DOTFILES_REPO} ${JIHARTIK_DOTFILES}
sudo chown -R jihartik:jihartik ${JIHARTIK_DOTFILES}
sudo -u jihartik -i stow -d ${JIHARTIK_DOTFILES} git tmux zsh
sudo chsh -s /usr/bin/zsh jihartik

# Setup .dotfiles for root
sudo git clone ${DOTFILES_REPO} ${ROOT_DOTFILES}
sudo -i stow -d ${ROOT_DOTFILES} git tmux zsh
sudo chsh -s /usr/bin/zsh root
