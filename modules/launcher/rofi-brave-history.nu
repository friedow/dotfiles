pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: string] {
    bash -c $"coproc \( ($command) >&/dev/null )"
  }

  def listEntries [] {
    cp ~/.config/BraveSoftware/Brave-Browser/Default/History ~/.cache/rofi-brave-history.db
    let history = (open ~/.cache/rofi-brave-history.db | query db "select * from urls" | sort-by last_visit_time | sort-by --reverse visit_count)
    
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    return ($history | format $'{title} - {url}($__0)info($__1){url}($__1)meta($__1)history' | to text)
  }

  def executeEntryAction [selectedEntry: string] {
    spawn $"brave \"($env.ROFI_INFO)\""
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
