#!/usr/bin/env bash
# dependencies:
# - pulseaudio
# - jq
#
# install all dependencies
# nix shell nixpkgs#pulseaudio nixpkgs#jq --command "zsh"

function listEntries() {
    pactl -f json list sinks | jq -r 'map([.description, .index] | @sh) | .[]'
}

function executeEntryAction() {
    pamixer --default > /dev/null  2>&1
}

function main() {
    local selectedEntry=$1

    if [[ -z $selectedEntry ]]; then
        listEntries
    else
        executeEntryAction $selectedEntry
    fi
}

main "$@"
