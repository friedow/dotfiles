{
  flake.modules.nixos.audio = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
    };
  };
}
