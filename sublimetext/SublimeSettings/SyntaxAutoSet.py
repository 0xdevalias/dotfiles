import sublime
import sublime_plugin
import os

# Ref:
#   Original ChatGPT conversation: https://chat.openai.com/chat/399b7d57-3ac2-4939-8aa5-a2b47c7d29f4
#
#   https://docs.sublimetext.io/guide/extensibility/plugins/
#   https://www.sublimetext.com/docs/porting_guide.html
#   https://www.sublimetext.com/docs/api_reference.html
#     https://www.sublimetext.com/docs/api_reference.html#sublime_plugin.EventListener
#     https://www.sublimetext.com/docs/api_reference.html#sublime_plugin.EventListener.on_load_async
#     https://www.sublimetext.com/docs/api_reference.html#sublime.load_settings

class SyntaxAutoSetListener(sublime_plugin.EventListener):
    def on_load_async(self, view):
        settings = sublime.load_settings('SyntaxAutoSet.sublime-settings')
        syntax_map = settings.get('syntax_map', {})

        filename = view.file_name()

        if filename:
            basename = os.path.basename(filename)

            syntax_file = syntax_map.get(basename, None)

            if syntax_file:
                view.set_syntax_file(syntax_file)
