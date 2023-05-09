pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def listEntries [] {
    let gitRepositoryPaths = (open ~/.cache/rofi-git-repositories.txt | lines | each { |it| $it | str replace "/.git$" "" } | wrap "path")
    let gitRepositories = ($gitRepositoryPaths | insert name { |it| $it.path | str replace ".*/([^/]+)" "$1" })

    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $gitRepositories | format $'{name}($__0)info($__1){path}($__1)meta($__1)git {path}' | to text
  }

  def executeEntryAction [selectedEntry: string] {
    bash -c $'code ($env.ROFI_INFO) >&/dev/null'
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
