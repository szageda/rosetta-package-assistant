#!/usr/bin/env bash

# File        : os-package-install.sh
# Description : Module for installing system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# packag_manager is an environment variable that is set to the system's package
# manager by identify_system_package_manager() in ropa.sh. If the variable is
# not set, e.g., a package manager is not identified, system_package_install()
# will not be run.
#
# Usage:
#   This function must be called from ropa() to be executed:
#     ropa install|in <package>

system_package_install() {
  print_action "Attempting to install to system: $*"

  case "$package_manager" in
    apt|dnf|zypper)
      sudo "$package_manager" install "$@"

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