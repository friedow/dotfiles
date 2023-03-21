pkgs:
pkgs.writeScriptBin "rofi-windows" ''
  #!${pkgs.nushell}/bin/nu

  def listEntries [] {
    let swayNodes = (${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '[recurse(.nodes[])]' | from json)
    let windows = ($swayNodes | where type == "con" | select name id)
    $windows | format $'{name}(0x[00] | decode utf-8)info(0x[1f] | decode utf-8){id}(0x[1f] | decode utf-8)meta(0x[1f] | decode utf-8)windows sway' | to text
  }

  def executeEntryAction [selectedEntry: string] {
    nohup ${pkgs.sway}/bin/swaymsg $"[con_id=($env.ROFI_INFO)]" focus | save /dev/null
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''