{ pkgs, ... }: {
  home-manager.users.christian.home = {
    packages = with pkgs; [ inkscape ];

    file.".config/inkscape/preferences.xml".source = ./preferences.xml;
    file.".config/inkscape/templates/default.svg".source =
      ./templates/default.svg;
    file.".config/inkscape/templates/Square.svg".source =
      ./templates/Square.svg;
  };
}
