#!/usr/bin/env nu

let landslide_ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtfzUTRW/R5n9bDK0gGLRF8+rgam3lvbqinPnvRpLxb"

let vaults = [ "landslide" ]

for vault in $vaults {
  print $"creating secrets for vault ($vault)"
  let items = (op item list --vault $vault --format json | from json)
  
  for item in $items {
    let itemDetails = (op item get $item.id --format json | from json)
    
    let name = ($itemDetails.fields | find --predicate {|field| $field.label == "secret name" } | first | get value)
    let value = ($itemDetails.fields | find --predicate {|field| $field.label == "secret value" } | first | get value)

    $value | nix run "nixpkgs#age" -- --encrypt --recipient $landslide_ssh | save $"secrets/($item.title).age"
    $"($name)=($value)" | nix run "nixpkgs#age" -- --encrypt --recipient $landslide_ssh | save $"secrets/env-($item.title).age"
  }
  print "secrets created"
}
