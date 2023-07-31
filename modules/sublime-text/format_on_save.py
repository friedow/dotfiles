import sublime_plugin
from subprocess import call

class FormatOnSave(sublime_plugin.EventListener):
  def on_post_save_async(self, view):
    syntax = view.syntax().name

    if syntax == "Nix":
      process = call(["nix", "run", "nixpkgs#nixfmt", "--", view.file_name()])
      return

    elif syntax == "Rust":
      process = call(["nix", "run", "nixpkgs#rustfmt", "--", view.file_name()])
      return

    elif syntax in ["JavaScript", "TypeScript", "UnitTest (TypeScript)", "JSON", "Vue Component", "HTML", "CSS", "Markdown", "JSX", "YAML"]:
      process = call(["nix", "run", "nixpkgs#nodePackages.prettier", "--", "-w", view.file_name()])
      return

    print("unhandled syntax: " + syntax)
