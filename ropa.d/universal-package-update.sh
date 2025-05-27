#!/usr/bin/env bash

# File        : universal-package-update.sh
# Description : Module for updating universal package formats (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
# 
# The for-loop iterates through the array of universal package managers
# supported by ROPA and checks if they are executable on the system. The
# varible found_universal_pm keeps track of whether any universal package
# manager was found (true). If a universal package manager is not found
# (false), a warning message is printed.
#
# Usage:
#   This function must be called from ropa() to be executed:
#     ropa update|up --universal|-u

universal_package_update() {
  declare -a universal_package_managers=(snap flatpak homebrew)
  found_universal_pm=false

  # Iterate through the array of universal package managers
  for pm in "${universal_package_managers[@]}"; do
    if command -v "$pm" &>/dev/null; then
      found_universal_pm=true
      print_header "Updating Universal Packages"

      if command -v snap &>/dev/null; then
        print_action "Searching for Snap updates..."
        sudo snap refresh
        echo "Snap packages are up-to-date."
      fi

      if command -v flatpak &>/dev/null; then
        print_action "Searching for Flatpak updates..."
        if [[ $(flatpak update | tee /dev/null | wc -l) -gt 3 ]] && \
          # Catch "end-of-life" runtime warnings
          flatpak update | grep -q '^Nothing to do.'; then
          print_success "No available Flatpak updates."
        else
          print_action "Installing updates..."
          flatpak update -y
          print_action "Cleaning up packages..."
          flatpak remove --unused -y
          print_success "Flatpak packages have been updated."
        fi
      fi

      if command -v brew &>/dev/null; then
        print_action "Searching for Homebrew updates..."
        brew update 2>/dev/null
        if [[ $(brew outdated --formula | wc -l) -gt 0 ]]; then
          print_action "Cleaning up packages..."
          brew cleanup
          print_success "Homebrew packages have been updated."
        else
          print_success "No available Homebrew updates."
        fi
      fi
    fi
  done

  if [[ "$found_universal_pm" = false ]]; then
    print_warning "No universal package manager was found. Skipping updates."
  fi

  return $?
}