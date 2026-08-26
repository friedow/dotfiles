{
  self,
  lib,
  ...
}:
let
  moduleDirectoryList = builtins.attrNames (builtins.readDir ./.);
  allModules = builtins.listToAttrs (
    builtins.map (entry: {
      name = lib.strings.removeSuffix ".nix" entry;
      value = ./. + "/${entry}";
    }) moduleDirectoryList
  );
in
{
  flake.modules.nixos = allModules // {
    agents =
      { ... }:
      {
        home-manager.users.christian = {
          home.packages = [
            self.packages.x86_64-linux.opencode
          ];
        };
      };

    desktop-modules.imports = with self.modules.nixos; [
      agents
      beeper
      blue-light-filter
      bluetooth
      bootscreen
      browser
      centerpiece
      clipboard
      cursor
      disable-services
      display-manager
      file-manager
      git
      home-manager
      lockscreen
      neovim
      networking
      nix-cli
      nix-tooling
      notifications
      password-manager
      printing
      privilige-manager
      resource-monitor
      session
      shell
      ssh
      terminal
      theme
      time
      usb-wakeup
      user-christian
      virtualisation
      window-manager
      yubikey
      zellij
    ];

    personal-modules.imports = [ ];

    work-modules.imports = with self.modules.nixos; [
      devenv
      glab
      xdg-utils
    ];
  };
}
