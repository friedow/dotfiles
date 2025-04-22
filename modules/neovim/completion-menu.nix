{ ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    blink-cmp = {
      enable = false;
      settings.signature.enabled = false;
    };
  };
}
