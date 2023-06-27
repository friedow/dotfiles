#!/usr/bin/env nu

mkdir secrets
nu build-secrets.nu
git add secrets/*

sudo nixos-rebuild build-vm

rm -r secrets
git add secrets/*