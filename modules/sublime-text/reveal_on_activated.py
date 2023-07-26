import sublime_plugin


class RevealOnActivated(sublime_plugin.EventListener):
  def on_activated_async(self, view):
    view.window().run_command("reveal_in_side_bar")
