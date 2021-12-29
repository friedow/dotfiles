{ config, pkgs, ... }:
{
	programs.git = {
    enable = true;
    userEmail = "christian@friedow.com";
    userName = "friedow";
  };
}