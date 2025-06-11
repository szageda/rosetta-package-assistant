#!/usr/bin/env bash

# File        : os-package-update.sh
# Description : Module for updating system packages (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# 'PACKAGE_MANAGER' global environment variable (defined in ropa.sh) holds the
# name of the system package manager executable. If the variable is emppty,
# base_system_update() will not be run.
#
# Usage:
#   ropa update|up <package> OR ropa update|up --full|-f
#
#
# TODO:
#   - It would be nice to combine the two functions into one.

##
## INDIVIDUAL PACKAGE UPDATE FUNCTION
##

system_package_update() {
  # If the user fails to specify package(s) to update,
  # ask them what they want to do.
  if [[ -z "$*" ]]; then
    print_err "No package(s) specified for update."
    print_warn "Do you want to update the operating system? [Y/n]"
    read -r answer

    case "$answer" in
      # Default to Yes if the user presses Enter.
      [Yy]|"")
        system_package_update_full
        ;;
      [Nn])
        print_err "Quitting."
        return 1
        ;;
      *)
        print_err "Invalid input. Aborting."
        return 1
        ;;
    esac
  else
    print_step "Attempting to update: $*"

    case "$PACKAGE_MANAGER" in
      apt|dnf)
        sudo "$PACKAGE_MANAGER" upgrade -y "$@"

        if [[ $? != "0" ]]; then
          print_err "Package update(s) failed."
          print_err "Please check the output of your package manager for details."
        fi
        ;;
      zypper)
        sudo zypper update -y "$@"

        if [[ $? != "0" ]]; then
          print_err "Package update(s) failed."
          print_err "Please check the output of your package manager for details."
        fi
        ;;
    esac
  fi

  return $?
}

##
## FULL SYSTEM UPDATE FUNCTION
##

system_package_update_full() {
  case "$PACKAGE_MANAGER" in
    apt)
      print_step "Searching for system package updates..."
      sudo apt update &>/dev/null

      if [[ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]]; then
        print_step "Installing updates..."
        sudo apt upgrade -y
        sudo apt autoremove -y
      else
        print_info "No available system updates."
      fi
      ;;
    dnf)
      print_action "Searching for system package updates..."
      sudo dnf check-update &>/dev/null

      if [[ $(dnf list updates 2>/dev/null | wc -l) -gt 1 ]]; then
        print_step "Installing updates..."
        sudo dnf upgrade -y
        sudo dnf autoremove -y
      else
        print_info "No available system updates."
      fi
      ;;
    zypper)
      print_step "Searching for system package updates..."
      sudo zypper refresh &>/dev/null

      if [[ $(zypper list-updates 2>/dev/null | wc -l) -gt 1 ]]; then
        print_step "Installing updates..."
        sudo zypper upgrade -y
        sudo zypper remove
      else
        print_info "No available system updates."
      fi
      ;;
  esac

  return $?
}
