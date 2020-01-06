#!/usr/bin/env bash
set -e

NETRC=/home/jihartik/.netrc
DOTFILES_REPO=https://github.com/chacal/dotfiles.git
JIHARTIK_DOTFILES=/home/jihartik/.dotfiles
ROOT_DOTFILES=/root/.dotfiles

# Clean up Github credentials on exit
trap '{ rm -f ${NETRC}; sudo rm -f /root/.netrc; exit 0; }' EXIT

cat <<EOF >${NETRC}
machine github.com
login chacal
password ${GITHUB_ACCESS_TOKEN}

machine api.github.com
login chacal
password ${GITHUB_ACCESS_TOKEN}
EOF

# Setup .dotfiles for jihartik
git clone ${DOTFILES_REPO} ${JIHARTIK_DOTFILES}
stow -d ${JIHARTIK_DOTFILES} git tmux zsh
sudo chsh -s /usr/bin/zsh jihartik

# Setup .dotfiles for root
sudo cp ${NETRC} /root/
sudo git clone ${DOTFILES_REPO} ${ROOT_DOTFILES}
sudo stow -d ${ROOT_DOTFILES} git tmux zsh
sudo chsh -s /usr/bin/zsh root
