#!/usr/bin/env nu
# nix shell "nixpkgs#pulseaudio" "nixpkgs#jq" --command "nu"

def listEntries [] {
    pactl -f json list sources | from json | select name description | insert font-weight { if $"($in.name)\n" == (pactl get-default-source) { $"bold" } else { $"normal" } } | format '"{font-weight}" "{description}" "{name}"' | to text | xargs printf '<span weight="%s">%s</span>\0info\x1f%s\n'
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
