# dotfiles

This repository contains my personal NixOS and home-manager configuration.

## Desktop setup

```
# ON THE BOOTSTICK
# generate a nixos hardware config and add the new host upstream
nixos-generate-config --show-hardware-config

# enter root mode
sudo -i

# set up the yubikey
ssh-keygen -K -f /root/.ssh/id_ed25519_sk
eval "$(ssh-agent -s)"
ssh-add /root/.ssh/id_ed25519_sk

# identify the disk to install on
lsblk

# install nixos
sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:friedow/dotfiles#HOSTNAME' --disk main /dev/DEVNAME
# reboot into the installed system

# ON THE BOOTED SYSTEM
# ensure home directory is set up
mkdir -p /home/christian/{.ssh,Code}

# plug in yubikey and fetch the ssh key
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

## Bootstick setup

```
# identify the disk to install on
lsblk

# create the bootstick
sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake 'github:friedow/dotfiles#bootstick' --disk main /dev/DEVNAME
```

## Setting up a new yubikey

Use yubikey-manager to change the yubikey pin

```
nix shell nixpkgs#yubikey-manager
ykman fido access change-pin
```

### PAM Setup

Generate pam keys

```
nix run nixpkgs#pam_u2f > /home/christian/.config/Yubico/u2f_keys
```

### SSH Setup

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
