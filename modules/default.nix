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
    desktop-modules.imports = with self.modules.nixos; [
      beeper
      blue-light-filter
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
      notes
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
    ];

    personal-modules.imports = [ ];

    work-modules.imports = with self.modules.nixos; [
      devenv
      codex
      glab
      xdg-utils
    ];
  };
}
