import sublime
import sublime_plugin

class StartCommandLoggingCommand(sublime_plugin.WindowCommand):
    def run(self):
        # Manually log the command execution
        print("command: start_command_logging")

        # Enable command logging
        sublime.log_commands(True)

        # Show the console panel
        self.window.run_command("show_panel", {"panel": "console"})

class StopCommandLoggingCommand(sublime_plugin.WindowCommand):
    def run(self):
        # Disable command logging
        sublime.log_commands(False)
