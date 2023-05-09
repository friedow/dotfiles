pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def listEntries [] {
    [ "Lock" "Sleep" "Hibernate" "Restart" "Shutdown" ] | to text
  }

  def executeEntryAction [selectedEntry: string] {
    if $selectedEntry == "Lock" {
      bash -c 'lock >&/dev/null'
      return
    }
  
    if $selectedEntry == "Sleep" {
      bash -c 'systemctl suspend-then-hibernate >&/dev/null'
      return
    }
    
    if $selectedEntry == "Hibernate" {
      bash -c 'systemctl hibernate >&/dev/null'
      return
    }

    if $selectedEntry == "Restart" {
      bash -c 'reboot >&/dev/null'
      return
    }

    if $selectedEntry == "Shutdown" {
      bash -c 'shutdown -h now >&/dev/null'
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
