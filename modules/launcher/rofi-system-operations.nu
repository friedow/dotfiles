pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: block] {
    let config_path = $nu.config-path
    let env_path = $nu.env-path
    let source_code = (view source $command | str trim -l -c '{' | str trim -r -c '}')
    ${pkgs.pueue}/bin/pueue add -p $"nu --config \"($config_path)\" --env-config \"($env_path)\" -c '($source_code)'" | save /dev/null
  }

  def listEntries [] {
    [ "Lock" "Sleep" "Hibernate" "Restart" "Shutdown" ] | to text
  }

  def executeEntryAction [selectedEntry: string] {
    if $selectedEntry == "Lock" {
      spawn { lock }
      return
    }
  
    if $selectedEntry == "Sleep" {
      spawn { systemctl suspend-then-hibernate }
      return
    }
    
    if $selectedEntry == "Hibernate" {
      spawn { systemctl hibernate }
      return
    }

    if $selectedEntry == "Restart" {
      spawn { reboot }
      return
    }

    if $selectedEntry == "Shutdown" {
      spawn { shutdown -h now }
      return
    }
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
