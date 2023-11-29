{ pkgs, ... }: {
  users.users.christian.shell = pkgs.fish;
  programs.fish.enable = true;

  home-manager.users.christian = {
    home.packages = [ pkgs.lsd pkgs.bat ];
    programs.fish = {
      enable = true;
      shellAliases = {
        l = "lsd -l";
        nd = "nix develop -c $SHELL";
        nrs = "sudo nixos-rebuild switch";
        b = "bat --theme OneHalfLight --paging=never";
      };

      functions = {
        n.body = "nix run nixpkgs#$argv[1] -- $argv[2..]";
        nu.body = "nix run nixpkgs-unstable#$argv[1] -- $argv[2..]";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        function fish_prompt -d "Write out the prompt"
          printf '> '
        end

        function fish_right_prompt -d "Write out the right prompt"
          printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        end
      '';

      plugins = [{
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }];
    };
  };
}
