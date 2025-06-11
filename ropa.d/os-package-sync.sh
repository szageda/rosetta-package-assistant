#!/usr/bin/env bash

# File        : os-package-sync.sh
# Description : Module for syncing repository indices (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# 'PACKAGE_MANAGER' global environment variable (defined in ropa.sh) holds the
# name of the system package manager executable. If the variable is emppty,
# system_package_sync() will not be run.
#
# Usage:
#   ropa sync|sy

system_package_sync() {
  # 'PACKAGE_MANAGER' is an environmental variable set
  # by identify_system_package_manager().
  case "$PACKAGE_MANAGER" in
    apt)
      print_step "Syncing local repository indices with remote sources..."
      sudo apt clean &>/dev/null
      sudo apt update

      if [[ $? != "0" ]]; then
        print_err "There was an error while syncing the repository indices."
        print_err "Please check the output of your package manager for details."
        return $?
      fi

      # Prompt if updates are available.
      if [[ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]]; then
        print_warn "Updates are available for your system packages."
        print_info "Run '\e[1;33mropa up\e[1;37m' or '\e[1;33mropa update\e[1;37m' to install them."
      fi
      ;;
    dnf)
      print_step "Syncing local repository indices with remote sources..."
      sudo dnf clean all &>/dev/null
      sudo dnf check-update

      if [[ $? != "0" ]]; then
        print_err "There was an error while syncing the repository indices."
        print_err "Please check the output of your package manager for details."
        return $?
      fi

      # Prompt if updates are available.
      if [[ $(dnf list updates 2>/dev/null | wc -l) -gt 1 ]]; then
        print_warn "Updates are available for your system packages."
        print_info "Run '\e[1;33mropa up\e[1;37m' or '\e[1;33mropa update\e[1;37m' to install them."
      fi
      ;;
    zypper)
      print_step "Syncing local repository indices with remote sources..."
      sudo zypper clean &>/dev/null
      sudo zypper refresh

      if [[ $? != "0" ]]; then
        print_err "There was an error while syncing the repository indices."
        print_err "Please check the output of your package manager for details."
        return $?
      fi

      # Prompt if updates are available
      if [[ $(zypper list-updates 2>/dev/null | wc -l) -gt 1 ]]; then
        print_warn "Updates are available for your system packages."
        print_info "Run '\e[1;33mropa up\e[1;37m' or '\e[1;33mropa update\e[1;37m' to install them."
      fi
      ;;
  esac

  return $?
}
