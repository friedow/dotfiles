pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: string] {
    bash -c $"coproc \( ($command) >&/dev/null )"
  }

  def listEntries [] {
    let swayNodes = (${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '[recurse(.nodes[])]' | from json)
    let windows = ($swayNodes | where type == "con" | select name id)

    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $windows | format $'{name}($__0)info($__1){id}($__1)meta($__1)windows sway' | to text
  }

  def executeEntryAction [selectedEntry: string] {
    spawn $"${pkgs.sway}/bin/swaymsg [con_id=($env.ROFI_INFO)] focus"
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
