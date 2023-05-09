pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def highlightDefaultMicrophone [microphones: table] {
    $microphones | insert font-weight { |it|
      if $it.name == (${pkgs.pulseaudio}/bin/pactl get-default-source) {
        $"bold"
      } else {
        $"normal"
      } 
    }
  }

  def printMicrophones [microphones: table] {
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $microphones | format $'<span weight="{font-weight}">{description}</span>($__0)info($__1){name}($__1)meta($__1)audio microphones' | to text
  }

  def listEntries [] {
    let microphones = (${pkgs.pulseaudio}/bin/pactl -f json list sources | from json | select name description | where not name ends-with ".monitor")
    let microphonesWithFontWeight = (highlightDefaultMicrophone $microphones)
    printMicrophones $microphonesWithFontWeight
  }

  def executeEntryAction [selectedEntry: string] {
    bash -c $'${pkgs.pulseaudio}/bin/pactl set-default-source ($env.ROFI_INFO) >&/dev/null'
  }

  def main [selectedEntry?: string] {
    printf '\0markup-rows\x1ftrue\n'
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
