#!/usr/bin/env bash

# File        : os-package-update.sh
# Description : Module for updating system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# 'package_manager' global environment variable (defined in ropa.sh) holds the
# name of the system package manager executable. If the variable is emppty,
# base_system_update() will not be run.
#
# Usage:
#   ropa update|up OR ropa update|up --all|-a

system_package_update() {
  print_header "Updating Operating System Packages"
  print_action "Searching for system package updates..."

  # Choose the package manager command to run based on 'package_manager'.
  # After the command is run, the output is evaluated to determine if
  # there are any updates available. If there are, the updates are installed,
  # and unsued packages are removed.
  case "$package_manager" in
    apt)
      sudo apt update &>/dev/null
      if [[ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]]; then
        print_action "Installing updates..."
        sudo apt upgrade -y
        print_action "Cleaning up packages..."
        sudo apt autoremove -y
        print_success "System packages have been updated."
      else
        print_success "No available system updates."
      fi
      ;;
    dnf)
      sudo dnf check-update &>/dev/null
      if [[ $(dnf list updates 2>/dev/null | wc -l) -gt 1 ]]; then
        print_action "Installing updates..."
        sudo dnf upgrade -y
        print_action "Cleaning up packages..."
        sudo dnf autoremove -y
        print_success "System packages have been updated."
      else
        print_success "No available system updates."
      fi
      ;;
    zypper)
      sudo zypper refresh &>/dev/null
      if [[ $(zypper list-updates 2>/dev/null | wc -l) -gt 1 ]]; then
        print_action "Installing updates..."
        sudo zypper upgrade -y
        print_action "Cleaning up packages..."
        sudo zypper remove
        print_success "System packages have been updated."
      else
        print_success "No available system updates."
      fi
      ;;
  esac

  return $?
}