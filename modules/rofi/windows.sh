#!/usr/bin/env bash
# dependencies:
# - jq
#
# install all dependencies
# nix shell nixpkgs#jq nixpkgs#sway --command "zsh"

function listEntries() {
    swaymsg -t get_tree | jq '[recurse(.nodes[]) | del(.nodes) | {id,type} ]'
}

function executeEntryAction() {
    local entry=$1

    echo "executeEntryAction"
    echo $entry
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

# Recursive Descent: ..
#        Recursively  descends  ., producing every value. This is the same as the zero-argument recurse builtin (see below). This is intended to resemble the XPath // operator.
#        Note that ..a does not work; use ..|.a instead. In the example below we use ..|.a? to find all the values of object keys "a" in any object found "below" ..

#        This is particularly useful in conjunction with path(EXP) (also see below) and the ? operator.

#            jq '..|.a?'
#               [[{"a":1}]]
#            => 1
