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
  ## 图标大小
  defaults write com.apple.dock "tilesize" -int 42

  ## 开启自动隐藏
  defaults write com.apple.dock "autohide" -bool true

  ## 关闭显示最近APP
  defaults write com.apple.dock "show-recents" -bool false

  ## 设置动画效果为缩放
  defaults write com.apple.dock "mineffect" -string "scale"

  ## 显示所有图标
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

  ##边栏图标大小
  defaults write -g NSTableViewDefaultSizeMode -int 3

  ## 默认finder启动位置
  defaults write com.apple.finder NewWindowTarget -string "PfHm"

  ## 设置默认使用list view
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  ## 文件夹图标放在最前面
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  ## 默认从当前文件夹进行搜索
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  ## 关闭修改文件扩展名警告
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  ## 底部显示路径栏
  defaults write com.apple.finder ShowPathbar -bool true

  ## 关闭清空废纸篓警告
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  ## 关闭边栏实现最近标签
  defaults write com.apple.finder ShowRecentTags -bool false

  ## 设置list view的图标&文字大小
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ExtendedListViewSettingsV2:textSize 14" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ExtendedListViewSettingsV2:iconSize 32" ~/Library/Preferences/com.apple.finder.plist
  defaults import com.apple.finder ~/Library/Preferences/com.apple.finder.plist

  ## 重启生效
  killall Finder
}

function finder.reset() {
  defaults delete com.apple.finder
  killall Finder
}

function finder.kill() {
  killall Finder
}

###############################################################################
