{
  flake.modules.nixos.office =
    { pkgs-unstable, ... }:
    {
      home-manager.users.christian.home.packages = with pkgs-unstable; [
        gridcraft
        pdfcraft
        vectorcraft
        wordcraft
      ];
    };
}
