#!/usr/bin/env bash
###############################################################################
##
##       filename: domains.sh
##    description: defaults domains releated
##        created: 2023/07/18
##         author: ticktechman
##
###############################################################################

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

###############################################################################
