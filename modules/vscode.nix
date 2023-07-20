{ pkgs, ... }:
let fonts = import ../config/fonts.nix;
in {
  home-manager.users.christian = {
    # needed to store sign in information in gitlens
    services.gnome-keyring.enable = true;

    programs.vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        github.github-vscode-theme
        eamodio.gitlens
        jnoortheen.nix-ide
        esbenp.prettier-vscode
        rust-lang.rust-analyzer
        thenuprojectcontributors.vscode-nushell-lang
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss
      ];

      userSettings = {
        "editor.formatOnSave" = true;
        "window.menuBarVisibility" = "toggle";
        "workbench.activityBar.visible" = false;
        "workbench.statusBar.visible" = false;
        "workbench.editor.showTabs" = false;
        "explorer.compactFolders" = false;
        "editor.fontFamily" = "monospace, 'Noto Color Emoji'";
        "editor.fontLigatures" = true;
        "workbench.panel.opensMaximized" = "always";
        "terminal.integrated.defaultProfile.linux" = "nu";
        "files.autoSave" = "onFocusChange";
        "workbench.colorTheme" = "GitHub Light";
        "git-graph.dialog.createBranch.checkOut" = true;
        "git-graph.dialog.fetchRemote.prune" = true;
        "git-graph.dialog.resetCurrentBranchToCommit.mode" = "Hard";
        "git-graph.dialog.resetUncommittedChanges.mode" = "Hard";
        "git-graph.repository.commits.fetchAvatars" = true;
        "git-graph.repository.fetchAndPrune" = true;
        "git-graph.repository.fetchAndPruneTags" = true;
        "git.autofetch" = "all";
        "git.autofetchPeriod" = 120;
        "git.pruneOnFetch" = true;
        "[json]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[jsonc]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[vue]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
      };

      keybindings = [
        {
          "key" = "ctrl+up";
          "command" = "cursorMove";
          "args" = {
            to = "up";
            by = "line";
            value = 5;
          };
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+down";
          "command" = "cursorMove";
          "args" = {
            "to" = "down";
            "by" = "line";
            "value" = 5;
          };
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+t";
          "command" = "workbench.action.terminal.toggleTerminal";
          "when" = "terminal.active";
        }
        {
          "key" = "ctrl+l";
          "command" = "workbench.action.gotoLine";
        }
        {
          "key" = "ctrl+k";
          "command" = "workbench.action.quickOpen";
        }
        # {
        #   "key" = "ctrl+g";
        #   "command" = "extension.multiCommand.execute";
        #   "args" = { 
        #     "sequence" = [
        #       "git-graph.view"
        #       "workbench.view.scm"
        #     ];
        #   };
        # }
        # {
        #   "key" = "ctrl+p";
        #   "command" = "extension.multiCommand.execute";
        #   "args" = { 
        #     "sequence" = [
        #       "workbench.view.explorer"
        #       "workbench.action.quickOpen"
        #     ];
        #   };
        # }
      ];
    };
  };
}
