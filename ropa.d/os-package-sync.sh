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
  print_action "Cleaning local repository indices..."

  # Choose the package manager command to run based on 'PACKAGE_MANAGER':
  # First, delete the local repository index data. Secondly, download the
  # fresh source repository index data, then evaluate the exit code to
  # check if the download was successful. Prompt if the download failed or
  # new updates are available.
  case "$PACKAGE_MANAGER" in
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