#!/usr/bin/env bash
# dependencies:
# - pulseaudio
# - jq
#
# install all dependencies
# nix shell nixpkgs#pulseaudio nixpkgs#jq --command "zsh"

function getSinks() {
    pactl -f json list sinks | jq 'map({index, name, description})'
}

function getDefaultSink() {
    local defaultSinkName="$(pactl get-default-sink)"
    getSinks | jq "map(select(.name == \"$defaultSinkName\"))"
}

function getSinkDescriptions() {
    local sinks="$1"
    echo "$sinks" | jq -r 'map([.description] | @sh) | .[]'
}

function listEntries() {
    getSinkDescriptions "$(getDefaultSink)"
    # pactl -f json list sinks | jq -r 'map([.description, .index] | @sh) | .[]'
}

function executeEntryAction() {
    pamixer --default > /dev/null  2>&1
}

function main() {
    local selectedEntry="$1"

    if [[ -z $selectedEntry ]]; then
        listEntries
    else
        executeEntryAction "$selectedEntry"
    fi
}

main "$@"
