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
  case "$PACKAGE_MANAGER" in
    apt|dnf|zypper)
      print_action "Attempting to remove from system: $*"
      sudo "$PACKAGE_MANAGER" remove "$@"

      if [[ $? != "0" ]]; then
        print_err "There was an error while removing package(s)."
        print_err "Please check the output of your package manager for details."
        return $?
      else
        case "$PACKAGE_MANAGER" in
          apt|dnf)
            sudo "$PACKAGE_MANAGER" autoremove -y
            ;;
          zypper)
            sudo zypper remove --clean-deps -y
            ;;
        esac
      fi
  esac

  return $?
}
