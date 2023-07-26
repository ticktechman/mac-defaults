# What is Mac-defaults

This is a bundle of bash functions that change macOS default configurations. It is very personal profile. If it does NOT meet your requirements, fork the repo and change the code.

# HOW TO

```bash
## load all functions to current env
source mac-defaults.sh

## call defaults.set to set default conf
defaults.set

## set default conf by domain
defaults.mouse.set
defaults.keyboard.set
defaults.trackpad.set
defaults.dock.set
defaults.finder.set

## export conf to a xml file
defaults.export <domain>

## import a xml file to a domain, the domain name is the xml file name without '.xml' suffix
defaults.import <xmlfile>

## show plist file contents
plist.cat xxx.plist

## read & write a key of plist file
plist.read xxx.plist key
plist.write xxx.plist key value
```

# SPEC

- `defaults.dock.set`: 
  - Clear all icons in dock (except finder, trash)
  - change icon size to 42x42
  - Auto-hide
  - Do NOT show recents apps
  - Change minimazation effect to scale
- `defaults.finder.set`:
  - Use list view as default
  - Change list view icon size to 32x32, font-size to 14px
  - Show folder first.
  - Show all file extensions
  - Show larger side bar icon size
  - Open the home directory of current user when open finder
  - Show path bar at the bottom
  - Disable warning when empty trash
  - Disable warning when change file extension
  - Do NOT show recent files in side bar
  - Search the current directory when do searching
- `defaults.mouse.set`
  - disable natural scroll
  - speed up the track speed
- `defaults.keyboard.set`
  - speed up the key repeat rate
- `defaults.trackpad.set`
  - enable three-finger-drag
  - enable tap-to-click
