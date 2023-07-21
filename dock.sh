#!/usr/bin/env bash
###############################################################################
##
##       filename: dock.sh
##    description: dock releated defaults
##        created: 2023/07/21
##         author: ticktechman
##
###############################################################################

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

###############################################################################
