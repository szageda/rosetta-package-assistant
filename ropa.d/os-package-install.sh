#!/usr/bin/env bash

# File        : os-package-install.sh
# Description : Module for installing system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# 'PACKAGE_MANAGER' global environment variable (defined in ropa.sh) holds the
# name of the system package manager executable. If the variable is emppty,
# system_package_remove() will not be run.
#
# Usage:
#   ropa install|in <package>

system_package_install() {
  print_action "Attempting to install to system: $*"

  # Choose the package manager command to run based on 'PACKAGE_MANAGER'.
  # After the command is run, the package manager's exit code is evaluated
  # to check if the installation was successful.
  case "$PACKAGE_MANAGER" in
    apt|dnf|zypper)
      sudo "$PACKAGE_MANAGER" install "$@"

      if [[ $? == "0" ]]; then
        print_success "Package(s) installed to system successfully."
      else
        print_error "Package installation(s) failed."
        print_error "Please check the output of your package manager for details."
        return $?
      fi
      ;;
  esac

  return $?
}
