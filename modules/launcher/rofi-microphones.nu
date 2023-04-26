pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: block] {
    let config_path = $nu.config-path
    let env_path = $nu.env-path
    let source_code = (view source $command | str trim -l -c '{' | str trim -r -c '}')
    ${pkgs.pueue}/bin/pueue add -p $"nu --config \"($config_path)\" --env-config \"($env_path)\" -c '($source_code)'" | save /dev/null
  }

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
    spawn { ${pkgs.pulseaudio}/bin/pactl set-default-source $env.ROFI_INFO }
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
