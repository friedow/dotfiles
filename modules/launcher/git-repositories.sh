#!/usr/bin/env bash
# dependencies:
# - locate (use nix-locate)
# - sway
#
# install all dependencies
# nix shell nixpkgs#jq nixpkgs#sway --command "zsh"

function listEntries() {
    find $HOME -name .git | sed 's/^\(.*\/\(.*\)\)\/.git$/\2 \1/' | xargs printf '%s\0info\x1f%s\n'
}

function executeEntryAction() {
    coproc ( code "$ROFI_INFO"  > /dev/null  2>&1 )
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
