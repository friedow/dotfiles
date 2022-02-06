{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
	programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        octref.vetur
        editorconfig.editorconfig
        mhutchie.git-graph
        # TODO: comment in when NUR PR is accepted
        # ryuta46.multi-command
    ];
    userSettings = {
        "window.menuBarVisibility" = "toggle";
        "workbench.activityBar.visible" = false;
        "workbench.statusBar.visible" = false;
        "workbench.editor.showTabs" = false;
        "explorer.compactFolders" = false;
        "editor.fontFamily" = "'Fira Code'";
        "workbench.panel.opensMaximized" = "always";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        
    };
    keybindings = [
      {
        "key" = "ctrl+up";
        "command"= "cursorMove";
        "args"= {
          to = "up";
          by = "line";
          value = 5;
        };
        "when"= "editorTextFocus";
      }
      {
        "key"= "ctrl+down";
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
        "key" = "ctrl+g";
        "command" = "extension.multiCommand.execute";
        "args" = { 
          "sequence" = [
            "git-graph.view"
            "workbench.view.scm"
          ];
        };
      }
      {
        "key" = "ctrl+p";
        "command" = "extension.multiCommand.execute";
        "args" = { 
          "sequence" = [
            "workbench.view.explorer"
            "workbench.action.quickOpen"
          ];
        };
      }
    ];
  };
}
