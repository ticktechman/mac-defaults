#!/usr/bin/env bash
###############################################################################
##
##       filename: mac-defaults.sh
##    description: collect an typical setting for new macOS
##        created: 2023/07/21
##         author: ticktechman
##
###############################################################################

#######################################
## defaults domains releated
#######################################
declare -a default_privates=(
  ".GlobalPreferences"
  "com.apple.finder"
  "com.apple.dock"
  "com.apple.controlcenter"
  "com.googlecode.iterm2"
)

## show all domains
function defaults.domains() {
  defaults domains | tr ',' '\n'
}

## export all domains to xml files
function defaults.domains.export() {
  for one in $(defaults.domains); do
    defaults.export "$one"
  done
}

## export domain(s) to xml file(s)
function defaults.export() {
  [[ $# -lt 1 ]] && {
    echo "Usage: defaults.export domain1 [domain2 ...]"
    return 1
  }

  for one in "$@"; do
    echo "exporting $one"
    defaults export "${one}" - >"${one}.xml"
  done
}

## import a xml file to a domain
## NOTE: domain name is the xml filename without '.xml' file extension
function defaults.import() {
  [[ $# -lt 1 ]] && {
    echo "Usage: defaults.import xmlfile1 [xmlfile2 ...]"
    return 1
  }

  for one in "$@"; do
    local app="$(echo ${one//\.xml/})"
    echo "importing $app"
    defaults import "$app" - <"$one"
  done
}

function defaults.privates.export() {
  for one in "${default_privates[@]}"; do
    defaults.export "$one"
  done
}

function defaults.privates.import() {
  for one in "${default_privates[@]}"; do
    local fn="${one}.xml"
    ([[ -f "${fn}" ]] && defaults.import "${fn}") || echo "skip ${fn}"
  done
  killall Finder Dock iTerm2
}
function defaults.activate() {
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
}
function mouse.set() {
  defaults write -g com.apple.mouse.scaling -float 1.2
  defaults write -g com.apple.swipescrolldirection -bool false
  defaults.activate
}
function mouse.reset() {
  defaults delete -g com.apple.mouse.scaling
  defaults delete -g com.apple.swipescrolldirection
  defaults.activate
}

function keyboard.set() {
  defaults write -g KeyRepeat -int 2
  defaults write -g InitialKeyRepeat -int 25
  defaults.activate
}
function keyboard.reset() {
  defaults delete -g KeyRepeat
  defaults delete -g InitialKeyRepeat
  defaults.activate
}

function trackpad.set() {
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults.activate
}
function trackpad.reset() {
  defaults delete com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag
  defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag
  defaults delete com.apple.AppleMultitouchTrackpad Clicking
  defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking
  defaults.activate
}

#######################################
## dock releated
#######################################
## add an app to dock
function dock.addapp() {
  app="${1}"

  if open -Ra "${app}"; then
    echo "$app added to the Dock."

    defaults write com.apple.dock persistent-apps -array-add "
    <dict>
        <key>tile-data</key>
        <dict>
            <key>file-data</key>
            <dict>
                <key>_CFURLString</key>
                <string>${app}</string>
                <key>_CFURLStringType</key>
                <integer>0</integer>
            </dict>
        </dict>
    </dict>"
  else
    echo "ERROR: Application $1 not found."
  fi
}

## configure dock
function dock.set() {
  ## change icon size
  defaults write com.apple.dock "tilesize" -int 42

  ## auto hide dock
  defaults write com.apple.dock "autohide" -bool true

  ## don't show recent apps in dock
  defaults write com.apple.dock "show-recents" -bool false

  ## change animation effect to scale
  defaults write com.apple.dock "mineffect" -string "scale"

  ## show all app icons
  defaults write com.apple.dock "static-only" -bool false

  killall Dock
}

## clear all apps in dock
function dock.clear() {
  defaults delete com.apple.dock persistent-apps
  defaults delete com.apple.dock persistent-others
  killall Dock
}

## reset dock configurations
function dock.reset() {
  defaults delete com.apple.dock
  killall Dock
}

## restart dock
function dock.kill() {
  killall Dock
}

#######################################
## finder releated
#######################################
function finder.set() {
  defaults write -g AppleShowAllExtensions -bool true

  ## change sidebar icon size
  defaults write -g NSTableViewDefaultSizeMode -int 3

  ## default open $HOME
  defaults write com.apple.finder NewWindowTarget -string "PfHm"

  ## use list view by default
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  ## show folder first in finder window
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  ## search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  ## disable warning when change file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  ## show path bar below
  defaults write com.apple.finder ShowPathbar -bool true

  ## disable warning when empty trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  ## don't show recent tags in sidebar
  defaults write com.apple.finder ShowRecentTags -bool false

  ## change list view font & icon size
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ExtendedListViewSettingsV2:textSize 14" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ExtendedListViewSettingsV2:iconSize 32" ~/Library/Preferences/com.apple.finder.plist
  defaults import com.apple.finder ~/Library/Preferences/com.apple.finder.plist

  ## restart to take effect
  killall Finder
}

function finder.reset() {
  defaults delete com.apple.finder
  killall Finder
}

function plist.cat() {
  [[ $# -lt 1 ]] && {
    echo "Usage: plist.cat <xxx.plist> ..."
    return 1
  }

  for one in "$@"; do
    /usr/libexec/PlistBuddy -c 'print ":"' "$one"
  done
}

function plist.read() {
  [[ $# -ne 2 ]] && {
    echo "Usage: plist.read <xxx.plist> <key>"
    return 1
  }
  /usr/libexec/PlistBuddy -c "print \":${2}\"" "$1"
}

function plist.write() {
  [[ $# -ne 3 ]] && {
    echo "Usage: plist.write <xxx.plist> <key> <value>"
    return 1
  }
  /usr/libexec/PlistBuddy -c "set \":${2}\" \"${3}\"" "$1"
}

###############################################################################
