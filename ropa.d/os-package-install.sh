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
  case "$PACKAGE_MANAGER" in
    apt|dnf|zypper)
      print_action "Attempting to install to system: $*"
      sudo "$PACKAGE_MANAGER" install "$@"

      if [[ $? != "0" ]]; then
        print_err "There was an error while installing package(s)."
        print_err "Please check the output of your package manager for details."
        return $?
      fi
      ;;
  esac

  return $?
}
