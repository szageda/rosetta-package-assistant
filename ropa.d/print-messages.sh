#!/usr/bin/env bash

# File        : print-messages.sh
# Description : Functions for printing messages to the terminal (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT

print_step() {
  echo -e "\e[1;34m=> \e[1;37m$1\e[0m" >&1
}

print_info() {
  echo -e "\e[1;32m:: \e[1;37m$1\e[0m" >&1
}

print_warn() {
  echo -e "\e[1;33m:: \e[1;37m$1\e[0m" >&1
}

print_err() {
  echo -e "\e[1;31m:: \e[1;37m$1\e[0m" >&2
}

help() {
  echo -e "ROPA -- ROsetta Package Assistant -- is NOT a package manager. It is a front-end"
  echo -e "wrapper for GNU/Linux distributions providing a consistent and simplified"
  echo -e "command-line interface."
  echo -e "\n\e[1;37mSyntax: \e[0mropa \e[0;33m[COMMAND...] \e[0;34m[OPTION...] <package...>"
  echo -e "\n\e[1;37mCommands:"
  echo -e "  \e[1;33min\e[0m, \e[1;33minstall\e[0m     Install package(s) to the operating system"
  echo -e "  \e[1;33mrm\e[0m, \e[1;33mremove\e[0m      Remove package(s) from the operating system"
  echo -e "  \e[1;33msy\e[0m, \e[1;33msync\e[0m        Sync system package database with repositories"
  echo -e "  \e[1;33mup\e[0m, \e[1;33mupdate\e[0m      Perform package update(s) -- see Options"
  echo -e "  \e[1;33m-h\e[0m, \e[1;33m--help\e[0m      Display this message"
  echo -e "\n\e[1;37mOptions:"
  echo -e "  \e[1;34m-a\e[0m, \e[1;34m--all\e[0m       Perform full system \e[1;33mupdate\e[0m"
  echo -e "  \e[1;34m-g\e[0m, \e[1;34m--go\e[0m        \e[1;33mUpdate\e[0m the Go toolchain only (experimental)"
  echo -e "  \e[1;34m-r\e[0m, \e[1;34m--rust\e[0m      \e[1;33mUpdate\e[0m the Rust toolchain and Cargo packages only"
  echo -e "  \e[1;34m-s\e[0m, \e[1;34m--system\e[0m    \e[1;33mUpdate\e[0m the operating system only"
  echo -e "  \e[1;34m-u\e[0m, \e[1;34m--universal\e[0m \e[1;33mUpdate\e[0m universal packages (Flatpaks, Snaps, etc.) only"
  echo -e "\n\e[1;37mArguments:"
  echo -e "  \e[0m<\e[1;34mpackage...\e[0m>    \e[1;33mInstall\e[0m, \e[1;33mremove\e[0m, or \e[1;33mupdate\e[0m the specified package(s)"

  return 0
}
