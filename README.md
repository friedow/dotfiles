# dotfiles

This repository contains my personal NixOS and home-manager configuration.

## Usage

```
sudo mv /etc/nixos /etc/nixos.backup
git clone https://github.com/friedow/dotfiles.git /etc/nixos
sudo ln -s $PWD/dotfiles /etc/nixos
sudo nixos-rebuild switch
```
