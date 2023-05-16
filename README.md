# dotfiles

This repository contains my personal NixOS and home-manager configuration.

## Usage

```
sudo mv /etc/nixos /etc/nixos.backup
git clone https://github.com/friedow/dotfiles.git /etc/nixos
sudo ln -s $PWD/dotfiles /etc/nixos
sudo nixos-rebuild switch
```

Server setup

```
xargs -L1 parted --script /dev/sda -- <<EOF
mklabel msdos
mkpart primary fat32 1MiB 512MB
mkpart primary 512MB 2GB
mkpart primary 2GB 100%
set 1 boot on
print
EOF

mkfs.fat /dev/sda1
fatlabel /dev/sda1 BOOT

mkswap --label SWAP /dev/sda2
swapon /dev/sda2

mke2fs -t ext4 -L ROOT /dev/sda3
mount /dev/sda3 /mnt

mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

nixos-install --no-root-password
```
