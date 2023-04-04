pkgs:
pkgs.writeScriptBin "rofi-git-repositories" ''
  #!${pkgs.nushell}/bin/nu

  def listEntries [] {
    cat ~/.cache/rofi-git-repositories.txt
  }

  def executeEntryAction [selectedEntry: string] {
    nohup code $env.ROFI_INFO | save /dev/null
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
