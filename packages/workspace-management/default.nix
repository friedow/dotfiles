{ pkgs, inputs ? { } }:
let
  script = ./new-project.nu;
in
pkgs.symlinkJoin {
  name = "workspace-management";
  paths = [
    (pkgs.writeShellScriptBin "new-issue" ''
      exec ${pkgs.nushell}/bin/nu ${script} issue
    '')
    (pkgs.writeShellScriptBin "new-review" ''
      exec ${pkgs.nushell}/bin/nu ${script} review
    '')
  ];
}
