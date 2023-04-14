import sublime
import sublime_plugin

# Ref:
#   https://docs.sublimetext.io/guide/extensibility/plugins/
#   https://www.sublimetext.com/docs/porting_guide.html
#   https://www.sublimetext.com/docs/api_reference.html
#     https://www.sublimetext.com/docs/api_reference.html#sublime_plugin.EventListener
#     https://www.sublimetext.com/docs/api_reference.html#sublime_plugin.EventListener.on_activated_async
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View.window
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View.sel
#       https://www.sublimetext.com/docs/api_reference.html#sublime.Selection
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View.lines
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View.line
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View.full_line
#     https://www.sublimetext.com/docs/api_reference.html#sublime.View.text_point
#
#   https://forum.sublimetext.com/t/highlight-currently-open-file-in-the-project-tree/10306/8

class RevealCurrentFileInSidebarListener(sublime_plugin.EventListener):
  # Called when a view gains input focus. Runs in a separate thread, and does not block the application.
  #   https://www.sublimetext.com/docs/api_reference.html#sublime_plugin.EventListener.on_activated_async
  def on_activated_async(self, view):
    # print(f"opened {view.file_name()}")

    current_window = view.window()

    if current_window:
      current_window.run_command("reveal_in_side_bar")
