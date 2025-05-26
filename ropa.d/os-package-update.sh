#!/usr/bin/env bash

# File        : os-package-update.sh
# Description : Module for updating system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
# 
# packag_manager is an environment variable that is set to the system's package
# manager by identify_system_package_manager() in ropa.sh. If the variable is
# not set, e.g., a  package manager is not identified, base_system_update()
# will not be run.
#
# Usage:
#   This function must be called from ropa() to be executed:
#     ropa update|up OR ropa update|up --all|-a

base_system_update() {
  print_header "Updating Operating System Packages"
  print_action "Searching for system package updates..."

  # Search for updates and install them if found
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

  return 0
}