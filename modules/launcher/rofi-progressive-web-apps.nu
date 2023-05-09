pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: block] {
    let config_path = $nu.config-path
    let env_path = $nu.env-path
    let source_code = (view source $command | str trim -l -c '{' | str trim -r -c '}')
    ${pkgs.pueue}/bin/pueue add -p $"nu --config \"($config_path)\" --env-config \"($env_path)\" -c '($source_code)'"
  }

  def get_bookmarks_recursive [bookmark: table] {
    if $bookmark.type == 'folder' {
      return ($bookmark.children | each { |it| get_bookmarks_recursive $it } | flatten)
    }

    if $bookmark.type == 'url' {
      return [ $bookmark ]
    }

    return []
  }

  def listEntries [] {
    let bookmarks = (open ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks | from json | get roots | values | where name == 'Bookmarks' | get children | get 0 | where name == 'Progressive Web Apps' | get children | get 0 | each {|it| get_bookmarks_recursive $it} | flatten | inspect)
    
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    return ($bookmarks | format $'{name}($__0)info($__1){url}($__1)meta($__1)bookmarks {url}' | to text)
  }

  def executeEntryAction [selectedEntry: string] {
    bash -c $'brave --app="($env.ROFI_INFO)" >&/dev/null'
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
