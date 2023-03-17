#!/usr/bin/env nu
# nix shell "nixpkgs#pulseaudio" "nixpkgs#jq" --command "nu"

def highlightDefaultSpeaker [speakers: table] {
    $speakers | insert font-weight {
        if $"($in.name)\n" == (pactl get-default-source) {
            $"bold"
        } else {
            $"normal"
        } 
    }
}

def printSpeakers [speakers: table] {
    $speakers | format $'<span weight="{font-weight}">{description}</span>(0x[00] | decode utf-8)info(0x[1f] | decode utf-8){name}' | to text
}

def listEntries [] {
    let speakers = (pactl -f json list sources | from json | select name description | where not name ends-with ".monitor")
    let speakersWithFontWeight = (highlightDefaultSpeaker $speakers)
    printSpeakers $speakersWithFontWeight
}

def executeEntryAction [selectedEntry: string] {
    nohup pactl set-default-source $env.ROFI_INFO
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
