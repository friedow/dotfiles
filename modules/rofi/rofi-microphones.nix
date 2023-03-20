pkgs:
pkgs.writeScriptBin "rofi-microphones" ''
  #!${pkgs.nushell}/bin/nu

  def highlightDefaultMicrophone [microphones: table] {
      $microphones | insert font-weight {
          if $"($in.name)\n" == (${pkgs.pulseaudio}/bin/pactl get-default-sink) {
              $"bold"
          } else {
              $"normal"
          } 
      }
  }

  def printMicrophones [microphones: table] {
      $microphones | format $'<span weight="{font-weight}">{description}</span>(0x[00] | decode utf-8)info(0x[1f] | decode utf-8){name}(0x[1f] | decode utf-8)meta(0x[1f] | decode utf-8)audio microphones' | to text
  }

  def listEntries [] {
      let microphones = (${pkgs.pulseaudio}/bin/pactl -f json list sinks | from json | select name description | where not name ends-with ".monitor")
      let microphonesWithFontWeight = (highlightDefaultMicrophone $microphones)
      printMicrophones $microphonesWithFontWeight
  }

  def executeEntryAction [selectedEntry: string] {
      nohup ${pkgs.pulseaudio}/bin/pactl set-default-sink $env.ROFI_INFO
      listEntries
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
