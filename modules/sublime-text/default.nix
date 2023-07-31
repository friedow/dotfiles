{ pkgs, config, ... }: {
  # TODO: resolve the creation, stage and deletion problem for secrets!
  age.secrets.sublime-text-license = {
    file = ../../secrets/sublime-license.age;
    path = "/home/christian/.config/sublime-text/Local/License.sublime_license";
    owner = "christian";
    group = "users";
    mode = "600";
  };

  home-manager.users.christian.home = {
    packages = with pkgs; [ sublime4 ];

    # TODO: for some reason a chown on .config/sublime-text and merge is necessary for this to work.
    # TODO: You have to call "Install Package Control" from the command palette in sublime before this works
    file.".config/sublime-text/Packages/User/Preferences.sublime-settings" = {
      text = builtins.toJSON {
        "theme" = "ayu-light.sublime-theme";
        "color_scheme" = "Packages/ayu/ayu-light.sublime-color-scheme";
        "save_on_focus_lost" = true;
        "trim_trailing_white_space_on_save" = "all";
        "shift_tab_unindent" = true;
        "tab_size" = 2;
        "translate_tabs_to_spaces" = true;
        "hot_exit" = "disabled";
        "goto_anything_exclude_gitignore" = true;
      };
    };

    ### PLUGINS

    # curstom-made format on save plugin
    file.".config/sublime-text/Packages/User/format_on_save.py".source =
      ./format_on_save.py;

    # curstom-made reveal on file activated plugin
    file.".config/sublime-text/Packages/User/reveal_on_activated.py".source =
      ./reveal_on_activated.py;

    # advanced sidebar context menu
    file.".config/sublime-text/Packages/SideBarEnhancements".source =
      pkgs.fetchFromGitHub {
        owner = "titoBouzout";
        repo = "SideBarEnhancements";
        rev = "5.0.49";
        sha256 = "sha256-d0YQku6jLGKu4qsK13OdOc2+m/6dDRY7tQaexV7ThLI=";
      };

    # theme
    file.".config/sublime-text/Packages/ayu".source = pkgs.fetchFromGitHub {
      owner = "dempfi";
      repo = "ayu";
      rev = "v6.1.2";
      sha256 = "sha256-BySEfBs1yv7PIYbE1qRdlFKIjgsnynBZ+rix3oq7TEk=";
    };

    # file type icon set
    file.".config/sublime-text/Packages/A File Icon".source =
      pkgs.fetchFromGitHub {
        owner = "SublimeText";
        repo = "AFileIcon";
        rev = "3.24.1";
        sha256 = "sha256-y1Mw9mWqoj2XtllN5J1AOd6/iR8LSH44XtaMkw56w7M=";
      };

    # sync the color scheme between sublime text and sublime merge
    file.".config/sublime-text/Packages/Sync Merge Scheme".source =
      pkgs.fetchFromGitHub {
        owner = "rafmjr";
        repo = "SyncMergeScheme";
        rev = "v1.0.3";
        sha256 = "sha256-Wb0w/UGmwHAwrbnV24N1FFx6HI+2/AOZ2QeW26zwJC8=";
      };

    # LSP
    file.".config/sublime-text/Packages/LSP".source = pkgs.fetchFromGitHub {
      owner = "sublimelsp";
      repo = "LSP";
      rev = "4070-1.24.0";
      sha256 = "sha256-RlGLsdhT5P0k4C0CA2OOazfbRYLoe8BZjz9Ycdp/26w=";
    };

    # LSP dependency
    file.".config/sublime-text/Packages/backrefs".source =
      pkgs.fetchFromGitHub {
        owner = "facelessuser";
        repo = "sublime-backrefs";
        rev = "1.9.0";
        sha256 = "sha256-7WegP/per6eQuGDnFReKB8h/gOBNKgDtnQK6LJMNILs=";
      };

    # LSP dependency
    file.".config/sublime-text/Packages/bracex".source = pkgs.fetchFromGitHub {
      owner = "facelessuser";
      repo = "sublime-bracex";
      rev = "2.1.1";
      sha256 = "sha256-1/498PkLzNz7RQZHwMg6xWrnc8BnC2OxbbvYCoQejOk=";
    };

    # LSP dependency
    file.".config/sublime-text/Packages/mdpopups".source =
      pkgs.fetchFromGitHub {
        owner = "facelessuser";
        repo = "sublime-markdown-popups";
        rev = "4.2.2";
        sha256 = "sha256-pHAHfirPP4OBaGdDhp4LsuHaXqhIm0gwEpDiYVis0I4=";
      };

    # LSP dependency
    file.".config/sublime-text/Packages/pathlib".source = pkgs.fetchFromGitHub {
      owner = "packagecontrol";
      repo = "pathlib";
      rev = "v1.0.1";
      sha256 = "sha256-XsT++oBu1ALDwUKmYEs1MEEcU92+CW77JEa7C5WKvsw=";
    };

    # LSP dependency
    file.".config/sublime-text/Packages/pyyaml".source = pkgs.fetchFromGitHub {
      owner = "packagecontrol";
      repo = "pyyaml";
      rev = "v5.1.1";
      sha256 = "sha256-NAkpwmYGU6IVo++vHdVJ7BSRGq1zvb2oixXdD8NW6Io=";
    };

    # LSP dependency
    file.".config/sublime-text/Packages/wcmatch".source = pkgs.fetchFromGitHub {
      owner = "facelessuser";
      repo = "sublime-wcmatch";
      rev = "1.2.1";
      sha256 = "sha256-i/4kqV5BzpmTPpUeTVqHsGkBe+g/Wpjd+eyB4iXphFI=";
    };

    # LSP-* dependency
    file.".config/sublime-text/Packages/lsp_utils".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "lsp_utils";
        rev = "v2.2.1";
        sha256 = "sha256-2Pxtatj9G4q1ITaqnM60PHsgTIu1R4bzQCIdD5H8Pd0=";
      };

    # LSP-* dependency
    file.".config/sublime-text/Packages/sublime_lib".source =
      pkgs.fetchFromGitHub {
        owner = "SublimeText";
        repo = "sublime_lib";
        rev = "v1.5.2";
        sha256 = "sha256-tI5EPi2ixskJ1PYnGjHG4e8h7xyHvVgJZYqCogM0D4E=";
      };

    # LSP typescript
    file.".config/sublime-text/Packages/LSP-typescript".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-typescript";
        rev = "v2.4.0";
        sha256 = "sha256-uBwKYxurXJw97VLZZu6mqCtum8mtE2XeUFIVNfKDc+k=";
      };

    # LSP vue
    file.".config/sublime-text/Packages/LSP-volar".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-volar";
        rev = "v2.5.5";
        sha256 = "sha256-7PLqnOfsCxYkuKDmTL9Bzm1mvDLVi4XLCp7uix6GeNg=";
      };

    # syntax highlighting for vue
    file.".config/sublime-text/Packages/Vue Syntax Highlight".source =
      pkgs.fetchFromGitHub {
        owner = "vuejs";
        repo = "vue-syntax-highlight";
        rev = "st4-4.1.0";
        sha256 = "sha256-e+yN6o1KS2tKIeOZo9ckKUW6V/qw/fy9xKIJW8RIZB4=";
      };

    # LSP eslint
    file.".config/sublime-text/Packages/LSP-eslint".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-eslint";
        rev = "1.7.0";
        sha256 = "sha256-2T5piOn3n6XunGQ3Cam2T7QOWc07KLBTcWYV9p4KDJY=";
      };

    # LSP html
    file.".config/sublime-text/Packages/LSP-html".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-html";
        rev = "1.3.2";
        sha256 = "sha256-OiTyZs6NJfP2W2FU3bsk4aaZ4huoz8o2G8SyYLtISQc=";
      };

    # LSP css, less, sass, scss
    file.".config/sublime-text/Packages/LSP-css".source = pkgs.fetchFromGitHub {
      owner = "sublimelsp";
      repo = "LSP-css";
      rev = "1.1.1";
      sha256 = "sha256-hJENlU6EAkL94j4v68nkBU9R1031+EWx4Ir6ozpviCE=";
    };

    # LSP json
    file.".config/sublime-text/Packages/LSP-json".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-json";
        rev = "1.12.0";
        sha256 = "sha256-PiT/luOSH4nrPjtJdwlhaQ01nIqKXZPyP6kpRyTpfgg=";
      };

    # LSP yaml
    file.".config/sublime-text/Packages/LSP-yaml".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-yaml";
        rev = "v0.4.18";
        sha256 = "sha256-UTdFCzyPUjCFBY31YqiO8a2CUgkAfmd7cTzmnPERpTo=";
      };

    # LSP markdown
    file.".config/sublime-text/Packages/LSP-marksman".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-marksman";
        rev = "v1.0.11";
        sha256 = "sha256-D5R+Pp1rpipk5jkbc6Fp5vUmjAMxaxtD/US0LIEHHlQ=";
      };

    # LSP docker
    file.".config/sublime-text/Packages/LSP-dockerfile".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-dockerfile";
        rev = "v1.2.7";
        sha256 = "sha256-CAkAiyNMtLObeonBa5hrDxW7Ll12bLhbCDcwmp1WrBw=";
      };

    # syntax highlighting for docker files
    file.".config/sublime-text/Packages/Dockerfile Syntax Highlighting".source =
      pkgs.fetchFromGitHub {
        owner = "asbjornenge";
        repo = "Docker.tmbundle";
        rev = "v1.6.4";
        sha256 = "sha256-L9IDB7llI9grTY7kweNVPoiK0uVtlisc+iGpr2b0uls=";
      };

    # LSP rust
    file.".config/sublime-text/Packages/LSP-rust-analyzer".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-rust-analyzer";
        rev = "v1.5.0";
        sha256 = "sha256-L9IDB7llI9grTY7kweNVPoiK0uVtlisc+iGpr2b0uls=";
      };

    file.".config/sublime-text/Packages/User/LSP-rust-analyzer.sublime-settings" =
      {
        text = builtins.toJSON {
          "command" = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
        };
      };

    # LSP rust change detector
    file.".config/sublime-text/Packages/LSP-file-watcher-chokidar".source =
      pkgs.fetchFromGitHub {
        owner = "sublimelsp";
        repo = "LSP-file-watcher-chokidar";
        rev = "v1.0.2";
        sha256 = "sha256-1dAKqwpllkHxkdxuW51Sl+part1NfbjBb27nH9y1uDs=";
      };

    # # syntax highlighting for nu
    file.".config/sublime-text/Packages/Nushell".source = pkgs.fetchFromGitHub {
      owner = "stevenxxiu";
      repo = "sublime_text_nushell";
      rev = "v1.9.0";
      sha256 = "sha256-L8vQNQZESvacsyVuzX9y8HnGZnaBqpNKoSYASkW4JLo=";
    };

    # syntax highlighting for nix
    file.".config/sublime-text/Packages/Nix".source = pkgs.fetchFromGitHub {
      owner = "wmertens";
      repo = "sublime-nix";
      rev = "v2.3.2";
      sha256 = "sha256-1FfqlhPF5X+qwPxsw7ktyHKgH6VMKk0PV+LIXrGtbt4=";
    };

  };
}
