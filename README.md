# dotfiles

This repository contains my personal NixOS and home-manager configuration.

## Desktop setup

### Prepare a bootstick

1. Identify your USB drive
   ```nu
   let DISK = lsblk --output=name,type --filter='TYPE=="disk"' |
     from ssv --aligned-columns |
     get NAME |
     input list
   ```
2. Write the ISO to the USB drive (replace /dev/sdX)
   ```nu
   clan flash write --flake . \
     --ssh-pubkey ~/.ssh/id_ed25519_sk.pub \
     --keymap us \
     --language en_US.UTF-8 \
     --disk main $DISK \
     flash-installer
   ```

### Boot into the installer

1. Boot the prepared USB drive
2. Ensure the machine has an uplink (nmtui is available)
3. Get the IP of the machine

### Prepare the machine configuration

1. Create a configuration.nix for the machine
   ```nu
   let MACHINE = input "Machine name: "
   clan machines create $MACHINE
   ```
2. Generate a facter report for the machine
   ```nu
   let INSTALLER_IP = input "Machine ip: "
   clan machines init-hardware-config \
     --target-host $"root@($INSTALLER_IP)" \
     $MACHINE
   ```
3. Try to apply the disk configuration to get the list of disks for the machine
   ```nu
   clan templates apply disk luks-ext4 $MACHINE --set mainDisk ""
   ```
4. Create the disko.nix for the machine based on the luks-ext4 template
   ```nu
   let DISK_PATH = input "Disk path (/dev/disk/by-id/SOME_ID): "
   clan templates apply disk luks-ext4 $MACHINE --set mainDisk $DISK_PATH
   ```
5. Install the system
   ```nu
   clan machines install $MACHINE --target-host $"root@($INSTALLER_IP)"
   ```

### Finish the setup

1. Change the user password
   ```nu
   passwd
   ```
2. Setup directories in home
   ```nu
   mkdir ~/.ssh ~/code ~/.config/Yubico
   ```
3. Plug in the yubikey and fetch the ssh key
   ```nu
   cd ~/.ssh
   ssh-keygen -K
   ssh-add id_ed25519_sk_rk_yubikey
   ```
4. Generate u2f_keys file from yubikey
   ```nu
   nix run nixpkgs#pam_u2f |
     save ~/.config/Yubico/u2f_keys
   ```
5. Clone and symlink the dotfiles
   ```nu
   sudo mv /etc/nixos /etc/nixos.backup
   git clone git@github.com:friedow/dotfiles.git ~/code/friedow/dotfiles
   sudo ln -s ~/code/friedow/dotfiles /etc/nixos
   ```

## Setting up a new yubikey

Use yubikey-manager to change the yubikey pin

```nu
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

```

```

```

```
