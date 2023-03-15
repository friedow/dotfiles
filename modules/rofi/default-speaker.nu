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
    $speakers | format '"{font-weight}" "{description}" "{name}"\n' | to text | xargs printf '<span weight="%s">%s</span>\0info\x1f%s\n'
}

def listEntries [] {
    let speakers = (pactl -f json list sources | from json | select name description)
    let speakersWithFontWeight = (highlightDefaultSpeaker $speakers)
    printSpeakers $speakersWithFontWeight
}

def executeEntryAction [selectedEntry: string] {
    nohup pactl set-default-source $env.ROFI_INFO
}

def main [selectedEntry?: string] {
    printf '\0markup-rows\x1ftrue\n'
    if ($selectedEntry | length) > 0 {
        executeEntryAction $selectedEntry
    } else {
        listEntries
    }
}
