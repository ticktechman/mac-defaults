#!/usr/bin/env bash
###############################################################################
##
##       filename: devices.sh
##    description: mouse, keyboard, trackpad releated defaults
##        created: 2023/07/21
##         author: ticktechman
##
###############################################################################

function defaults.activate() {
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
}
function mouse.set() {
  defaults write .GlobalPreferences com.apple.mouse.scaling -float 1.2
  defaults.activate
}
function mouse.reset() {
  defaults delete .GlobalPreferences com.apple.mouse.scaling
  defaults.activate
}

function keyboard.set() {
  defaults write .GlobalPreferences KeyRepeat -int 2
  defaults write .GlobalPreferences InitialKeyRepeat -int 25
  defaults.activate
}
function keyboard.reset() {
  defaults delete .GlobalPreferences KeyRepeat
  defaults delete .GlobalPreferences InitialKeyRepeat
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

###############################################################################
