{ config, pkgs, ... }:
{
  environment.etc = {
    "firefox/policies/policies.json".source = "/etc/nixos/home/firefox/policies.json";
  };
}