#!/usr/bin/env bash

# Print messages to the terminal

print_header() {
  echo -e "\n\e[1;35m:: \e[1;37m$1\e[0m" >&1
}

print_action() {
  echo -e "\e[1;34m=> \e[1;37m$1\e[0m" >&1
}

print_success() {
  echo -e "\e[1;32m:: \e[1;37m$1\e[0m" >&1
}

print_warning() {
  echo -e "\e[1;33m:: \e[1;37m$1\e[0m" >&1
}

print_error() {
  echo -e "\e[1;31m:: \e[1;37m$1\e[0m" >&2
}

print_help() {
  echo -e "ROPA -- ROsetta Package Assistant -- is not a package manager. It acts as a unified front-end wrapper for GNU/Linux distributions providing a consistent and simplified command-line interface."
  echo -e "\n\e[1;37mSyntax: \e[0mropa \e[0;33m[COMMAND...] \e[0;34m[OPTION...]"
  echo -e "\n\e[1;37mCommands:"
  echo -e "  \e[1;33min\e[0m, \e[1;33minstall\e[0m     Install package(s) to the operating system"
  echo -e "  \e[1;33mrm\e[0m, \e[1;33mremove\e[0m      Remove package(s) from the operating system"
  echo -e "  \e[1;33mup\e[0m, \e[1;33mupdate\e[0m      Perform package update(s) -- see Options"
  echo -e "  \e[1;33m-h\e[0m, \e[1;33m--help\e[0m      Display this message"
  echo -e "\n\e[1;37mOptions:"
  echo -e "  \e[0m('\e[1;33mup\e[0m' or '\e[1;33mupdate\e[0m')"
  echo -e "  \e[1;34m-a\e[0m, \e[1;34m--all\e[0m       Performs full system update (option can also be omitted)"
  echo -e "  \e[1;34m-u\e[0m, \e[1;34m--universal\e[0m Updates universal package formats (Flatpaks, Snaps, etc.)"
  echo -e "  \e[1;34m-r\e[0m, \e[1;34m--rust\e[0m      Updates the Rust toolchain and Cargo packages"

  return 0
}