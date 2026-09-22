# Corne Firmware


## Flash Both Halves

Run this from the repository root:

```sh
nix run .#corne-flash
```

The flashing tool prompts for each half. For each prompt:

1. Connect the requested half to USB.
2. Enter bootloader mode by double-tapping its reset button. The controller
   appears as a USB mass-storage drive.
3. Confirm the prompt so the matching `.uf2` file is copied to the drive.
4. Wait for the controller to reboot, then repeat for the other half.

Flash both halves whenever the firmware or `corne.conf` changes. The halves
must run matching firmware versions for the split connection to work reliably.

## Build Without Flashing

To build the firmware and inspect the generated files without programming a
controller:

```sh
nix build .#corne-firmware
```

The resulting directory contains separate left and right UF2 files. To print
the output path without creating a `result` symlink:

```sh
nix build .#corne-firmware --print-out-paths --no-link
```

## Pairing After Flashing

Normally, flashing does not erase Bluetooth settings. If the keyboard no
longer connects after changing firmware, remove the keyboard from the laptop's
Bluetooth settings and pair it again. The `BT_CLR` binding in the custom layer
can clear the active Bluetooth profile before pairing again.
