#!/usr/bin/env bash

# File        : os-package-remove.sh
# Description : Module for removing system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# packag_manager is an environment variable that is set to the system's package
# manager by identify_system_package_manager() in ropa.sh. If the variable is
# not set, e.g., a package manager is not identified, system_package_remove()
# will not be run.
#
# Usage:
#   This function must be called from ropa() to be executed:
#     ropa remove|rm <package>

system_package_remove() {
  print_action "Attempting to remove from system: $*"

  # Search for updates and install them if found
  case "$package_manager" in
    apt|dnf|zypper)
      sudo "$package_manager" remove "$@"

      if [[ $? == "0" ]]; then
        print_action "Cleaning up unused dependencies..."
        case "$package_manager" in
          apt|dnf)
            sudo "$package_manager" autoremove -y
            ;;
          zypper)
            sudo zypper remove --clean-deps -y
            ;;
        esac
        print_success "Package(s) removed from the system successfully."
      else
        print_error "Package removal(s) failed."
        print_error "Please check the output of your package manager for details."
        return $?
      fi
      ;;
  esac

  return $?
}