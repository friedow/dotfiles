{ config, pkgs, ... }:
{
    nixpkgs.config.allowUnfree = true;
	programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            octref.vetur
        ];
        userSettings = {
            "window.menuBarVisibility" = "toggle";
            "workbench.activityBar.visible" = false;
            "workbench.statusBar.visible" = false;
            "workbench.editor.showTabs" = false;
            "explorer.compactFolders" = false;
        };
    };
}