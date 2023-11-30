# dotfiles

This repository contains my personal NixOS and home-manager configuration.

## Usage

```
# ensure home directory is set up
mkdir -p /home/christian/Code
mkdir -p /home/christian/.ssh

# plug in yubikey & get ssh keys from yubikey
ssh-keygen -K -f /home/christian/.ssh/id_ed25519_sk

# clone dotfiles
sudo mv /etc/nixos /etc/nixos.backup
git clone https://github.com/friedow/dotfiles.git /home/christian/Code/friedow/dotfiles
sudo ln -s /home/christian/Code/friedow/dotfiles /etc/nixos

# rebuild system
sudo nixos-rebuild switch

# generate u2f_keys file from yubikey
mkdir -p /home/christian/.config/Yubico && nix run nixpkgs#pam_u2f > /home/christian/.config/Yubico/u2f_keys
```

## Server setup

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

## SSH Setup

Guide: https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html

Generating new SSH Keys stored on a yubikey:

```
ssh-keygen -t ed25519-sk -O resident -O application=ssh:yubikey -O verify-required
```

Copying SSH keys stored on a yubikey to the local system:

```
cd /home/christian/.ssh && ssh-keygen -K
```

Manage credentials with the yubikey manager:

```
nix run nixpkgs#yubikey-manager fido credentials list
```

## Yubikey PAM setup

Generate u2f_keys file using `pamu2fcfg` from yubikey

```
nix run nixpkgs#pam_u2f > /home/christian/.config/Yubico/u2f_keys
```
