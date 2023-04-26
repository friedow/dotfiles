pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: block] {
    let config_path = $nu.config-path
    let env_path = $nu.env-path
    let source_code = (view source $command | str trim -l -c '{' | str trim -r -c '}')
    ${pkgs.pueue}/bin/pueue add -p $"nu --config \"($config_path)\" --env-config \"($env_path)\" -c '($source_code)'" | save /dev/null
  }

  def listEntries [] {
    let gitRepositoryPaths = (open ~/.cache/rofi-git-repositories.txt | lines | each { |it| $it | str replace "/.git$" "" } | wrap "path")
    let gitRepositories = ($gitRepositoryPaths | insert name { |it| $it.path | str replace ".*/([^/]+)" "$1" })

    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $gitRepositories | format $'{name}($__0)info($__1){path}($__1)meta($__1)git {path}' | to text
  }

  def executeEntryAction [selectedEntry: string] {
    spawn { code $env.ROFI_INFO }
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
