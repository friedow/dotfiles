pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def listEntries [] {
    [ "Sleep" "Hibernate" "Restart" "Shutdown" ] | to text
  }

  def executeEntryAction [selectedEntry: string] {
    # TODO: add lock action
  
    if $selectedEntry == "Sleep" {
      nohup systemctl suspend-then-hibernate
      return
    }
    
    if $selectedEntry == "Hibernate" {
      nohup systemctl hibernate
      return
    }

    if $selectedEntry == "Restart" {
      nohup reboot
      return
    }

    if $selectedEntry == "Shutdown" {
      nohup shutdown -h now
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
