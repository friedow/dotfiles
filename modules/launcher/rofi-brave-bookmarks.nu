pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def get_bookmarks_recursive [bookmark: table] {
    if $bookmark.name == 'Progressive Web Apps' {
      return []
    }

    if $bookmark.type == 'folder' {
      return ($bookmark.children | each { |it| get_bookmarks_recursive $it } | flatten)
    }

    if $bookmark.type == 'url' {
      return [ $bookmark ]
    }

    return []
  }

  def listEntries [] {
    let bookmarks = (open ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks | from json | get roots | values | each {|it| get_bookmarks_recursive $it} | flatten | inspect)
    
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    return ($bookmarks | format $'{name}($__0)info($__1){url}($__1)meta($__1)bookmarks {url}' | to text)
  }

  def executeEntryAction [selectedEntry: string] {
    bash -c $'brave ($env.ROFI_INFO) >&/dev/null'
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
