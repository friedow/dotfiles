#!/usr/bin/env bash
# dependencies:
# - pulseaudio
# - jq
# - awk
#
# install all dependencies
# nix shell nixpkgs#pulseaudio nixpkgs#jq nixpkgs#gawk --command "zsh"

function getSinks() {
    pactl -f json list sinks | jq 'map({index, name, description})'
}

function getDefaultSink() {
    local defaultSinkName="$(pactl get-default-sink)"
    getSinks | jq "map(select(.name == \"$defaultSinkName\"))"
}

function getSinkDescriptions() {
    local sinks="$1"
    echo "$sinks" | jq -r 'map(.description | @sh) | .[]'
}

function getSinkDescriptionsAndIds() {
    local sinks="$1"
    echo "$sinks" | jq -r 'map([.description, .index] | @sh) | .[]'
}

function listEntries() {
    getSinkDescriptions "$(getDefaultSink)" | xargs printf '%s\0info\x1fexpand defaultSink\n'
}

function executeEntryAction() {
    local action="$ROFI_INFO"

    if [[ "$action" == "expand defaultSink" ]]; then
        getSinkDescriptions "$(getDefaultSink)" | xargs printf '%s\0info\x1fcollapse defaultSink\x1factive\x1ftrue\n'
        getSinkDescriptionsAndIds "$(getSinks)" | xargs printf '%s\0info\x1fsetDefaultSink %s\n'
    
    elif [[ "$action" == "collapse defaultSink" ]]; then
        getSinkDescriptions "$(getDefaultSink)" | xargs printf '%s\0info\x1fexpand defaultSink\x1factive\x1ftrue\n'
    
    elif [[ "$action" == "setDefaultSink"* ]]; then
        echo "$action" | awk '{ print $2 }' | xargs pactl set-default-sink > /dev/null  2>&1
        getSinkDescriptions "$(getDefaultSink)" | xargs printf '%s\0info\x1fexpand defaultSink\x1factive\x1ftrue\n'
    fi
}

function main() {
    local theme="$(echo '
        element {
            children: [element-text,textbox-custom];
        }
        textbox-custom {
            content: "My Message";
            text-color: White;
        }
    ' | paste -sd ' ')"

    echo -e "\0theme\x1f$theme"
    local selectedEntry="$1"

    if [[ -z $selectedEntry ]]; then
        listEntries
    else
        executeEntryAction "$selectedEntry"
    fi
}

main "$@"
