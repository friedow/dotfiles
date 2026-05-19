{ inputs, lib, ... }:
{
  perSystem =
    { system, ... }:
    {
      packages = rec {
        corne-firmware = inputs.zmk-nix.legacyPackages.${system}.buildSplitKeyboard {
          name = "corne-firmware";

          src = lib.sourceFilesBySuffices ./. [
            ".conf"
            ".keymap"
            ".overlay"
            ".yml"
          ];

          board = "nice_nano_v2";
          shield = "corne_%PART% nice_view_adapter nice_view";

          zephyrDepsHash = "sha256-F03oJNHWmHlpFc1JHyvqX02WL+Pg6ZcNWpCaiDfJANA=";

          meta = {
            description = "ZMK firmware for the Corne wireless 5-column keyboard with nice!view display";
            license = lib.licenses.mit;
            platforms = lib.platforms.all;
          };
        };

        corne-flash = inputs.zmk-nix.packages.${system}.flash.override { firmware = corne-firmware; };
        corne-update = inputs.zmk-nix.packages.${system}.update;
      };
    };
}
