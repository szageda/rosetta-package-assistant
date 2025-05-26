#!/usr/bin/env bash

# File        : ropa.sh
# Description : ROsetta Package Assistant -- package manager front-end wrapper
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# ROPA -- ROsetta Package Assistant -- is not a package manager. It acts as a
# unified front-end wrapper for GNU/Linux distributions providing a consistent
# and simplified command-line interface, allowing you to manage your system's
# packages without needing to remember the specific syntax for each underlying
# package manager.
#
# Usage:
#   Place ropa.sh and ropa.d in the same directory in your $PATH (for example:
#   ~/.local/bin). Source ropa.sh in your ~/.bashrc or ~/.bash_profile to make
#   it is available in your CLI.
#
# Syntax:
#   ropa [COMMAND...] [OPTION...]
 
# LOAD THE ROPA ENVIRONMENT
# 
# Important: ropa.sh must be in the same directory as ropa.d.

ropa_dir="$(dirname "${BASH_SOURCE[0]}")/ropa.d"
for file in "$ropa_dir"/*.sh; do
  if [[ -f "$file" ]]; then
    source "$file"
  fi
done

# SYSTEM PACKAGE MANAGER IDENTIFICATION
#
# This function identifies the system package manager by checking if a
# compatiable package manager, declared in the array, is executable in
# the system.
# If a compatible package manager is found, it is saved in the variable
# package_manager and exported globally as an environment variable.

identify_system_package_manager() {
  declare -a package_managers=(apt dnf zypper)
  package_manager=""

  # Iterate through the array of package managers
  for pm in "${package_managers[@]}"; do
    if command -v "$pm" &>/dev/null; then
      package_manager="$pm"

      # Export the variable as an environment variable
      export package_manager
      break
    else
      print_error "A compatible package manager could not be identified."
      print_error "Verify your package manager is in your PATH, and supported by ROPA."
      return 1
    fi
  done

  return 0
}

# The Main Function

ropa() {
  # Make sure a system package manager has been ID'ed
  # before running any commands.
  if [[ -z "$package_manager" ]]; then
    identify_system_package_manager
  fi

  # Command and Option Parsing
  # 
  # $1 = command
  # $2 = option
  case $1 in
    -h|--help)
      print_help
      ;;
    in|install)
      case $2 in
        # "ropa install" with no package name
        "")
          print_error "No package specified for installation."
          return 1
          ;;
        *)
          shift
          system_package_install "$@"
          ;;
      esac
      ;;
    up|update)
      case $2 in
        # "ropa update" with no option (equals to "--all" or "-a")
        "")
          base_system_update && \
          universal_package_update && \
          rust_package_update
          ;;
        --all|-a)
          base_system_update && \
          universal_package_update && \
          rust_package_update
          ;;
        --universal|-u)
          universal_package_update
          ;;
        --rust|-r)
          rust_package_update
          ;;
        *)
          print_error "Invalid option: $2"
          print_error "Use '\e[1;33m-h\e[1;37m' or '\e[1;33m--help\e[1;37m' for available options."
          return 1
          ;;
      esac
      ;;
    *)
      print_error "Invalid command: $1"
      print_error "Use '\e[1;33m-h\e[1;37m' or '\e[1;33m--help\e[1;37m' for available commands."
      return 1
      ;;
  esac
}