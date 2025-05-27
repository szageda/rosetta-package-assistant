#!/usr/bin/env bash

# File        : os-package-sync.sh
# Description : Module for syncing repository indices (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# packag_manager is an environment variable that is set to the system's package
# manager by identify_system_package_manager() in ropa.sh. If the variable is
# not set, e.g., a package manager is not identified, system_package_sync()
# will not be run.
#
# Usage:
#   This function must be called from ropa() to be executed:
#     ropa sync|sy

system_package_sync() {
  print_header "Syncing Package Database with Remote Repositories"
  print_action "Cleaning local repository indices..."

  case "$package_manager" in
    apt)
      sudo apt clean &>/dev/null
      print_success "Local repository indices have been cleaned."

      print_action "Downloading latest repository indices from configured sources..."
      sudo apt update

      if [[ $? == "0" ]]; then
        print_success "Package database indices have been updated."

        # Prompt if updates are available
        sudo apt update &>/dev/null
        if [[ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]]; then
          print_warning "Updates are available for your system packages."
          print_warning "Run '\e[1;33mropa up\e[1;37m' or '\e[1;33mropa update\e[1;37m' to install them."
        else
          print_success "Your system is already up-to-date, nothing to update."
        fi
      else
        print_error "Failed to update repository indices."
        print_error "Please check the output of your package manager for details."
        return $?
      fi
      ;;
    dnf)
      sudo dnf clean all &>/dev/null
      print_success "Local repository indices have been cleaned."

      print_action "Downloading latest repository indices from configured sources..."
      sudo dnf check-update

      if [[ $? == "0" ]]; then
        print_success "Package database indices have been updated."

        # Prompt if updates are available
        sudo dnf check-update &>/dev/null
        if [[ $(dnf list updates 2>/dev/null | wc -l) -gt 1 ]]; then
          print_warning "Updates are available for your system packages."
          print_warning "Run '\e[1;33mropa up\e[1;37m' or '\e[1;33mropa update\e[1;37m' to install them."
        else
          print_success "Your system is already up-to-date, nothing to update."
        fi
      else
        print_error "Failed to update repository indices."
        print_error "Please check the output of your package manager for details."
        return $?
      fi
      ;;
    zypper)
      sudo zypper clean &>/dev/null
      print_success "Local repository indices have been cleaned."

      print_action "Downloading latest repository indices from configured sources..."
      sudo zypper refresh

      if [[ $? == "0" ]]; then
        print_success "Package database indices have been updated."

        # Prompt if updates are available
        sudo zypper refresh &>/dev/null
        if [[ $(zypper list-updates 2>/dev/null | wc -l) -gt 1 ]]; then
          print_warning "Updates are available for your system packages."
          print_warning "Run '\e[1;33mropa up\e[1;37m' or '\e[1;33mropa update\e[1;37m' to install them."
        else
          print_success "Your system is already up-to-date, nothing to update."
        fi
      else
        print_error "Failed to update repository indices."
        print_error "Please check the output of your package manager for details."
        return $?
      fi
      ;;
  esac

  return $?
}