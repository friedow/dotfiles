pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: string] {
    bash -c $"coproc \( ($command) >&/dev/null )"
  }

  def listEntries [] {
    [ "Lock" "Sleep" "Hibernate" "Restart" "Shutdown" ] | to text
  }

  def executeEntryAction [selectedEntry: string] {
    if $selectedEntry == "Lock" {
      spawn "lock"
      return
    }
  
    if $selectedEntry == "Sleep" {
      spawn "systemctl suspend-then-hibernate"
      return
    }
    
    if $selectedEntry == "Hibernate" {
      spawn "systemctl hibernate"
      return
    }

    if $selectedEntry == "Restart" {
      spawn "reboot"
      bash -c 'reboot >&/dev/null'
      return
    }

    if $selectedEntry == "Shutdown" {
      spawn "shutdown -h now"
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
