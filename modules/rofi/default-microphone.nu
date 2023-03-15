#!/usr/bin/env nu
# nix shell "nixpkgs#pulseaudio" "nixpkgs#jq" --command "nu"

def getDefaultSink

def listEntries [] {
    pactl -f json list sinks | from json | select index name description | format '"{description}" "{name}"' | to text | xargs printf '%s\0info\x1f%s\n'
}

def executeEntryAction [selectedEntry: string] {
    nohup pactl set-default-sink $env.ROFI_INFO
    $env.ROFI_INFO
}

def main [selectedEntry?: string] {
    if ($selectedEntry | length) > 0 {
        executeEntryAction $selectedEntry
    } else {
        listEntries
    }
}
