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
      gtk
      home-manager
      inkscape
      lockscreen
      neovim
      networking
      nix-cli
      notes
      notifications
      password-manager
      privilige-manager
      resource-monitor
      session
      shell
      sublime-merge
      ssh
      terminal
      theme
      time
      usb-wakeup
      user-christian
      window-manager
      yubikey
    ];

    personal-modules.imports = [ ];

    work-modules.imports = with self.modules.nixos; [
      devenv
      glab
      xdg-utils
    ];
  };
}
