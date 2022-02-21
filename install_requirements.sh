#!/bin/bash

COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
  echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

case $(uname) in
  Darwin)
    IS_DARWIN=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true
    IS_DARWIN=false
  ;;
esac

case $(uname -m) in
  arm64)
    IS_ARM=true
    IS_INTEL=false
  ;;
  x86_64)
    IS_ARM=false
    IS_INTEL=true
  ;;
esac

if "${IS_DARWIN}"; then
  title "Install requirements for macOS"
  TMPWORKDIR="/tmp/tmux-temp-deps"
  if "${IS_INTEL}"; then
    info "Downloading lavoisel/osx-cpu-temp"
    git clone https://github.com/lavoiesl/osx-cpu-temp ${TMPWORKDIR}
    info "Compiling and installing lavoisel/osx-cpu-temp"
    (cd "${TMPWORKDIR}"; make && sudo make install)
  elif "${IS_ARM}"; then
    info "Downloading narugit/m1_temperature"
    git clone https://github.com/narugit/m1_temperature ${TMPWORKDIR}
    info "Compiling and installing narugit/m1_temperature"
    (cd "${TMPWORKDIR}"; make && sudo mv ./smctemp /usr/local/bin/)
  fi
  rm -rf "${TMPWORKDIR}"
fi
