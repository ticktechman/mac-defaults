#!/usr/bin/env bash
###############################################################################
##
##       filename: finder.sh
##    description: finder releated defaults
##        created: 2023/07/21
##         author: ticktechman
##
###############################################################################

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
