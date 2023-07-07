#!/usr/bin/env nu

# TODO: add hurricane ssh host key
# sudo ssh-keygen -t ed25519 -C "email@example.com" -f /etc/ssh/ssh_host_ed25519_key
let landslide_ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtfzUTRW/R5n9bDK0gGLRF8+rgam3lvbqinPnvRpLxb"
let avalanche_ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILL471jTxGCPhgfYxi2MHMlg3MUSgEROwo/1d7rZniHp"
let tsunami_ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtEZp2KJHV/EswMGAjQDn2AdRlRQwJbcX9Z5N5Hg2Ox"

let vaults = [ "dotfiles-desktop" "dotfiles-server" ]

for vault in $vaults {
  print $"creating secrets for vault ($vault)"
  let items = (op item list --vault $vault --format json | from json)
  
  for item in $items {
    let itemDetails = (op item get $item.id --format json | from json)

    
    let name = ($itemDetails.fields | filter {|field| $field.label == "secret name" } | first | get value)
    let value = ($itemDetails.fields | filter {|field| $field.label == "secret value" } | first | get value)

    $value | nix run "nixpkgs#age" -- --encrypt --recipient $landslide_ssh --recipient $avalanche_ssh --recipient $tsunami_ssh | save $"secrets/($item.title).age"
    $"($name)=($value)" | nix run "nixpkgs#age" -- --encrypt --recipient $landslide_ssh --recipient $avalanche_ssh --recipient $tsunami_ssh | save $"secrets/env-($item.title).age"
  }
  print "secrets created"
}
