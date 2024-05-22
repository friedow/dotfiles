{ pkgs, ... }: {
  users.users.christian.shell = pkgs.fish;
  programs.fish.enable = true;

  home-manager.users.christian = {
    home.packages = with pkgs; [ eza bat libwebp ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        l = "eza -l";
        ls = "eza -l";
        ll = "eza -l";
        nd = "nix develop -c $SHELL";
        nrs = "sudo nixos-rebuild switch";
        cat = "bat --theme OneHalfLight --paging never --style plain";
        yubikey-unlock =
          "${pkgs.yubikey-manager}/bin/ykman fido fingerprints list";
      };

      functions = {
        n.body = "nix run nixpkgs#$argv[1] -- $argv[2..]";
        nu.body = "nix run nixpkgs-unstable#$argv[1] -- $argv[2..]";
        ns.body = "nix shell nixpkgs#$argv[1]";
        bearer-inspect.body =
          "echo $argv[1] | cut -d. -f2  | base64 --decode --ignore-garbage";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        function fish_prompt -d "Write out the prompt"
          printf '> '
        end
      '';

      plugins = [{
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }];
    };
  };
}
