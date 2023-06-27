pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: string] {
    bash -c $"coproc \( ($command) >&/dev/null )"
  }

  def printTabs [tabs: table] {
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $tabs | format $'{title}($__0)info($__1){id}($__1)meta($__1)browser brave tabs' | to text
  }

  def listEntries [] {
    # TODO: package chrome-remote-interface in nixpkgs
    # follow these instructions: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/doc/languages-frameworks/javascript.section.md#adding-and-updating-javascript-packages-in-nixpkgs-javascript-adding-or-updating-packages
    # todo: use the commented line when chrome-remote-interface it is packaged
    # let tabs = (${pkgs.nodejs}/bin/npx chrome-remote-interface -- list | from json | where type == "page" | select title id)
    let tabs = (npx chrome-remote-interface -- list | from json | where type == "page" | select title id)
    printTabs $tabs
  }

  def executeEntryAction [selectedEntry: string] {
    # todo: use the commented line when chrome-remote-interface it is packaged
    # spawn $"${pkgs.nodejs}/bin/npx chrome-remote-interface -- activate ($env.ROFI_INFO)"
    spawn $"npx chrome-remote-interface -- activate ($env.ROFI_INFO)"
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
