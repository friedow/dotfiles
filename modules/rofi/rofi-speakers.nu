pkgs:
pkgs.writeScriptBin "rofi-speakers" ''
  #!${pkgs.nushell}/bin/nu
  # TODO: preserver cursor position and prompt

  def highlightDefaultSpeaker [speakers: table] {
      $speakers | insert font-weight {
          if $"($in.name)\n" == (${pkgs.pulseaudio}/bin/pactl get-default-sink) {
              $"bold"
          } else {
              $"normal"
          } 
      }
  }

  def printSpeakers [speakers: table] {
      $speakers | format $'<span weight="{font-weight}">{description}</span>(0x[00] | decode utf-8)info(0x[1f] | decode utf-8){name}(0x[1f] | decode utf-8)meta(0x[1f] | decode utf-8)audio speakers headphones' | to text
  }

  def listEntries [] {
      let speakers = (${pkgs.pulseaudio}/bin/pactl -f json list sinks | from json | select name description | where not name ends-with ".monitor")
      let speakersWithFontWeight = (highlightDefaultSpeaker $speakers)
      printSpeakers $speakersWithFontWeight
  }

  def executeEntryAction [selectedEntry: string] {
      nohup ${pkgs.pulseaudio}/bin/pactl set-default-sink $env.ROFI_INFO | save /dev/null
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
