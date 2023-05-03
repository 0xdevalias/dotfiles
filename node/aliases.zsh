alias npm-list="npm list --depth=0"
alias npm-list-global="npm list -g --depth=0"

alias npm-outdated="npm outdated"
alias npm-outdated-global="npm outdated -g"

# https://github.com/dylang/npm-check
alias npm-check="npx npm-check"

alias yarn-check-cache-size="du -sh ~/Library/Caches/Yarn"
alias yarn-clean-cache="yarn-check-cache-size; rm -rf ~/Library/Caches/Yarn/*; yarn-check-cache-size"
alias clean-yarn-cache="yarn-clean-cache"

alias list-package-scripts="jq '.scripts' package.json"
alias show-package-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"

alias npm-list-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"
alias npm-show-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"
alias list-npm-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"
alias show-npm-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"

alias yarn-list-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"
alias yarn-show-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"
alias list-yarn-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"
alias show-yarn-scripts="echo \"alias for 'list-package-scripts'\" && list-package-scripts"

###########
# Electron
###########

alias electron-find-apps='find /Applications -name "Electron Framework.framework"'

# https://www.electronjs.org/docs/latest/tutorial/fuses#the-easy-way
#   https://github.com/electron/fuses#readme
# alias electron-fuse-check="npx @electron/fuses read --app"
alias electron-fuse-check="function _electron_fuse_check() { npx @electron/fuses read --app \${1:?Error: Please specify path to electron app.}; }; _electron_fuse_check"

alias electron-asar='npx asar'
alias electron-asar-list="function _electron_asar_list() { npx asar list \${1:?Error: Please specify path to asar file.}; }; _electron_asar_list"
alias electron-asar-list-is-pack="function _electron_asar_list_is_pack() { npx asar list --is-pack \${1:?Error: Please specify path to asar file.}; }; _electron_asar_list_is_pack"
alias electron-asar-list-only-packed="function _electron_asar_list_only_packed() { npx asar list --is-pack \${1:?Error: Please specify path to asar file.} | grep -v unpack }; _electron_asar_list_only_packed"
alias electron-asar-list-only-unpacked="function _electron_asar_list_only_unpacked() { npx asar list --is-pack \${1:?Error: Please specify path to asar file.} | grep unpack }; _electron_asar_list_only_unpacked"

function _electron_run_app() {
  # Get the app name from the first argument
  APP_NAME=${1:?Error: Please specify name of electron application to run.}
  shift

  # Set the path to the app folder
  APP_PATH="/Applications/${APP_NAME}.app"

  # Check if the app exists in /Applications
  if [ -d "${APP_PATH}" ]; then
    echo "Found ${APP_NAME}.app in /Applications"

    # Check if the app uses Electron
    if [ -d "${APP_PATH}/Contents/Frameworks/Electron Framework.framework" ]; then
      echo "${APP_NAME}.app uses Electron"

      # Find the main executable and run it
      MAIN_EXECUTABLE=$(plutil -p "${APP_PATH}/Contents/Info.plist" | awk -F'"' '/CFBundleExecutable/{print $4}')
      if [ -n "${MAIN_EXECUTABLE}" ]; then
        env | grep 'ELECTRON'

        # Run the main app binary (passing it the args provided)
         (set -x; "${APP_PATH}/Contents/MacOS/${MAIN_EXECUTABLE}" $@)
      else
          echo "Could not find main executable for ${APP_NAME}.app"
      fi
    else
        echo "${APP_NAME}.app does not use Electron"
    fi
  else
      echo "${APP_NAME}.app not found in /Applications"
  fi
}
alias electron-run-app="_electron_run_app"
alias electron-run-app-with-inspect-main="function _electron_run_app_with_inspect_main() { _electron_run_app \${1:?Error: Please specify name of electron application to run.} --inspect-brk=1337; }; _electron_run_app_with_inspect_main"
alias electron-run-app-as-node="ELECTRON_RUN_AS_NODE=1 _electron_run_app"

alias electron-run-beeper-localdev="_electron_run_app Beeper localdev localapi"
