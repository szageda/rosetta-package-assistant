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
#   Source ropa.sh in your ~/.bashrc or ~/.bash_profile to make it available
#   as a CLI command.
#
# Syntax:
#   ropa [COMMAND...] [OPTION...]

# LOAD THE ROPA ENVIRONMENT

# Load all files with .sh exentsion from the ropa.d directory. ropa.d is
# expected to be in the same directory as this script.
ropa_dir="$(dirname "${BASH_SOURCE[0]}")/ropa.d"
for file in "$ropa_dir"/*.sh; do
  if [[ -f "$file" ]]; then
    source "$file"
  fi
done

# SYSTEM PACKAGE MANAGER IDENTIFICATION

identify_system_package_manager() {
  declare -a package_managers=(apt dnf zypper)
  package_manager=""

  # Iterate through the array of package manager names to identify
  # if a system package manager command is executable.
  for pm in "${package_managers[@]}"; do
    if command -v "$pm" &>/dev/null; then
      # Save the package manager executable name to a variable,
      # then export the variable as an environment variable,
      # so it can be used by other functions and scripts.
      package_manager="$pm"
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

# MAIN FUNCTION

# This function exposes the ROPA command-line interface with command and option
# parsing. It is the main entry point for the ROPA CLI.
ropa() {
  # Identify the system package manager before proceeding.
  if [[ -z "$package_manager" ]]; then
    identify_system_package_manager
  fi

  # Command and Option Parsing
  command="$1"
  option="$2"

  case "$command" in
    -h|--help)
      print_help
      ;;
    in|install)
      case "$option" in
        # Fail if no package name is specified.
        "")
          print_error "No package(s) specified for installation."
          return 1
          ;;
        *)
          shift
          system_package_install "$@"
          ;;
      esac
      ;;
    rm|remove)
      case "$option" in
        # Fail if no package name is specified.
        "")
          print_error "No package(s) specified for removal."
          return 1
          ;;
        *)
          shift
          system_package_remove "$@"
          ;;
      esac
      ;;
    sy|sync)
      case "$option" in
        # This command takes no options, so it must fail otherwise.
        "")
          system_package_sync
          ;;
        *)
          print_error "Invalid option: $2"
          print_error "Use '\e[1;33m-h\e[1;37m' or '\e[1;33m--help\e[1;37m' for available options."
          return 1
          ;;
      esac
    ;;
    up|update)
      case "$option" in
        # Perform full system update.
        --all|-a)
          system_package_update_full && \
          universal_package_update && \
          rust_package_update
          ;;
        # Update universal packages only (e.g., Flatpak, Snap).
        --universal|-u)
          universal_package_update
          ;;
        # Update the Rust toolchain and Cargo packages only.
        --rust|-r)
          rust_package_update
          ;;
        # Update system packages only.
        --system|-s)
          system_package_update_full
          ;;
        *)
        # Update individual packages.
          shift
          system_package_update_individual "$@"
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