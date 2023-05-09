# Ref:
#   https://github.com/jonlabelle/SublimeJsPrettier
#     https://github.com/jonlabelle/SublimeJsPrettier/issues/269
#       Allow unsaved files to be formatted with prettier without saving
#
#   https://www.sublimetext.com/docs/api_reference.html#sublime.View.file_name
#   https://www.sublimetext.com/docs/api_reference.html#sublime.View.substr
#   https://www.sublimetext.com/docs/api_reference.html#sublime.View.settings
#     https://www.sublimetext.com/docs/api_reference.html#sublime.Settings
#       https://www.sublimetext.com/docs/scope_naming.html
#   https://www.sublimetext.com/docs/api_reference.html#sublime.View.replace
#   https://www.sublimetext.com/docs/api_reference.html#sublime.error_message
#   https://www.sublimetext.com/docs/api_reference.html#sublime.message_dialog
#   https://www.sublimetext.com/docs/api_reference.html#sublime.status_message
#
# prettier --help
#   ..snip..
#   --parser <flow|babel|babel-flow|babel-ts|typescript|acorn|espree|meriyah|css|less|scss|json|json5|json-stringify|graphql|markdown|mdx|vue|yaml|glimmer|html|angular|lwc>
#                          Which parser to use.
#   ..snip..
#   --file-info <path>     Extract the following info (as JSON) for a given file path. Reported fields:
#                          * ignored (boolean) - true if file path is filtered by --ignore-path
#                          * inferredParser (string | null) - name of parser inferred from file path
#   ..snip..
# --stdin-filepath <path>  Path to the file to pretend that stdin comes from.

import sublime
import sublime_plugin

import os.path
import subprocess

class PrettierFormatCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        # Get the filename of the current file (if saved)
        file_name = self.view.file_name()
        if file_name:
            file_name = os.path.normpath(file_name)

        # Get the full contents of the file
        entire_view_region = sublime.Region(0, self.view.size())
        code = self.view.substr(entire_view_region)

        # TODO: Handle formatting only a given selection of a file as well?
        #   https://www.sublimetext.com/docs/api_reference.html#sublime.View.sel

        # Get the syntax of the current file
        syntax = self.view.settings().get('syntax')

        # Map the syntax to the appropriate Prettier parser
        plugin_settings = sublime.load_settings('PrettierFormat.sublime-settings')
        parser_map = plugin_settings.get('parser_map', {})
        parser = parser_map.get(syntax)

        # If we have a file_name then prettier can attempt to guess the syntax for us
        if syntax not in parser_map and not file_name:
            sublime.error_message(f"[PrettierFormat] Error: Unsupported syntax type: {syntax}")
            return

        # Build the Prettier command with the appropriate parser
        prettier_cmd = ['prettier']

        # If the file is saved, pass it's filename to prettier with --stdin-filepath
        if file_name:
            prettier_cmd += ['--stdin-filepath', file_name]

        # Tell prettier which parser to use based on the file syntax
        if parser:
            prettier_cmd += ['--parser', parser]

        try:
            prettier_proc = subprocess.Popen(
                prettier_cmd,
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            prettier_stdout, prettier_stderr = prettier_proc.communicate(code.encode('utf-8'))
        except Exception as e:
            sublime.error_message(f"[PrettierFormat] Error: {str(e)}")
            return

        # If Prettier returned an error, print the error message and exit
        if prettier_proc.returncode != 0:
            sublime.error_message(f"[PrettierFormat] Prettier Error (RC={prettier_proc.returncode}): {prettier_stderr.decode('utf-8').strip()}")
            return

        # Replace the contents of the file with the formatted code
        formatted_code = prettier_stdout.decode('utf-8')
        self.view.replace(edit, entire_view_region, formatted_code)

        sublime.message_dialog('[PrettierFormat] Code formatted successfully')
        sublime.status_message('[PrettierFormat] Code formatted successfully')
