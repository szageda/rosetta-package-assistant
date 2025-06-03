#!/usr/bin/env bash

# File        : os-package-remove.sh
# Description : Module for removing system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# 'PACKAGE_MANAGER' global environment variable (defined in ropa.sh) holds the
# name of the system package manager executable. If the variable is emppty,
# system_package_remove() will not be run.
#
# Usage:
#   ropa remove|rm <package>

system_package_remove() {
  print_action "Attempting to remove from system: $*"

  # Choose the package manager command to run based on 'PACKAGE_MANAGER'.
  # After the command is run, the package manager's exit code is evaluated to
  # determine if the removal was successful. If it was, unused dependencies
  # are cleaned up; otherwise, an error message is printed.
  case "$PACKAGE_MANAGER" in
    apt|dnf|zypper)
      sudo "$PACKAGE_MANAGER" remove "$@"

      if [[ $? == "0" ]]; then
        print_action "Cleaning up unused dependencies..."
        case "$PACKAGE_MANAGER" in
          apt|dnf)
            sudo "$PACKAGE_MANAGER" autoremove -y
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