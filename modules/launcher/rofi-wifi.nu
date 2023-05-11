pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def spawn [command: string] {
    bash -c $"coproc \( ($command) >&/dev/null )"
  }

  def addFontWeightColumn [wifiNetworks: table] {
    $wifiNetworks | insert font-weight { |it|
      if $it.IN-USE == "*" {
        $"bold"
      } else {
        $"normal"
      }
    }
  }

  def listEntries [] {
    let wifiNetworks = (open ~/.cache/rofi-wifi.txt | from ssv --aligned-columns | uniq-by SSID)
    let wifiNetworks = (addFontWeightColumn $wifiNetworks)
    
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $wifiNetworks | format $'<span weight="{font-weight}">{BARS}  {SSID}</span>($__0)info($__1){SSID}($__1)meta($__1)wifi networks' | to text
  }

  def executeEntryAction [selectedEntry: string] {
    spawn $"${pkgs.networkmanager}/bin/nmcli device wifi connect ($env.ROFI_INFO)"
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
