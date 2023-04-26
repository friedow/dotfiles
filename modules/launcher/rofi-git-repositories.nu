pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def listEntries [] {
    let gitRepositoryPaths = (open ~/.cache/rofi-git-repositories.txt | each { |it| $it | str replace "/.git$" "" } | wrap "path")
    $gitRepositoryPaths | insert name { |it| $it.path | str replace ".*/([^/]+)" "$1" }
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
