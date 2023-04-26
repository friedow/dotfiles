pkgs: ''
  #!${pkgs.nushell}/bin/nu

  def addFontWeightColumn [wifiNetworks: table] {
    $wifiNetworks | insert font-weight {
      if $in.IN-USE == "*" {
        $"bold"
      } else {
        $"normal"
      }
    }
  }

  def listEntries [] {
    let wifiNetworks = (open ~/.cache/rofi-wifi.txt | from ssv --aligned-columns | uniq-by SSID)
    let wifiNetworks = addFontWeightColumn $wifiNetworks
    
    # rofi row option separators
    let __0 = (0x[00] | decode utf-8)
    let __1 = (0x[1f] | decode utf-8)
    $wifiNetworks | format $'<span weight="{font-weight}">{SSID}</span>SPACE<span>{BARS}</span>($__0)info($__1){SSID}($__1)meta($__1)wifi networks' | to text
  }

  def executeEntryAction [selectedEntry: string] {
    nohup ${pkgs.networkmanager}/bin/nmcli device wifi connect $env.ROFI_INFO | save /dev/null
  }

  def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
      executeEntryAction $selectedEntry
    } else {
      listEntries
    }
  }
''
