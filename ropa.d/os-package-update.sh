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

# INDIVIDUAL PACKAGE UPDATE FUNCTION

system_package_update() {
  # If the user fails to specify package(s) to update,
  # ask them what they want to do.
  if [[ -z "$*" ]]; then
    print_error "No package(s) specified for update."
    print_warning "Do you want to update the operating system? [Y/n]"
    read -r answer

    case "$answer" in
      # Default to Yes if the user presses Enter.
      [Yy]|"")
        system_package_update_full
        ;;
      [Nn])
        print_error "Quitting."
        return 1
        ;;
      *)
        print_error "Invalid input. Aborting."
        return 1
        ;;
    esac
  else
    print_action "Attempting to update: $*"

    # Choose the package manager command to run based on 'PACKAGE_MANAGER'.
    # After the command is run, the package manager's exit code is evaluated
    # to check if the package update was successful.
    case "$PACKAGE_MANAGER" in
      apt|dnf)
        sudo "$PACKAGE_MANAGER" upgrade -y "$@"

        if [[ $? == "0" ]]; then
          print_success "Package(s) updated successfully."
        else
          print_error "Package update(s) failed."
          print_error "Please check the output of your package manager for details."
        fi
        ;;
      zypper)
        sudo zypper update -y "$@"

        if [[ $? == "0" ]]; then
          print_success "Package(s) updated successfully."
        else
          print_error "Package update(s) failed."
          print_error "Please check the output of your package manager for details."
        fi
        ;;
    esac
  fi

  return $?
}

# FULL SYSTEM UPDATE FUNCTION

system_package_update_full() {
  # Choose the package manager command to run based on 'PACKAGE_MANAGER'.
  # After the command is run, the output is evaluated to determine if
  # there are any updates available. If there are, the updates are installed,
  # and unsued packages are removed.
  case "$PACKAGE_MANAGER" in
    apt)
      sudo apt update &>/dev/null
      print_action "Searching for system package updates..."

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
      print_action "Searching for system package updates..."

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
      print_action "Searching for system package updates..."

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
