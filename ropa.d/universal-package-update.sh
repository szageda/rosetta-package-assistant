#!/usr/bin/env bash

# File        : universal-package-update.sh
# Description : Module for updating universal package formats (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# Update packages of universal package managers such as Snap and Flatpak.
#
# Usage:
#   ropa update|up --universal|-u

universal_package_update() {
  declare -a universal_package_managers=(snap flatpak homebrew)
  found_universal_pm=false

  # Iterate through the array of package manager names first to identify
  # if any of them are available on the system, and control the results
  # with the 'found_universal_pm' variable -- this is important for the
  # if-statement below the for-loop. Reasoning: if 'found_universal_pm'
  # is false, the warning message is printed every time the for-loop iterates.
  for pm in "${universal_package_managers[@]}"; do
    if command -v "$pm" &>/dev/null; then
      found_universal_pm=true

      if command -v snap &>/dev/null; then
        print_step "Searching for Snap updates..."
        sudo snap refresh
        echo "Snap packages are up-to-date."
      fi

      if command -v flatpak &>/dev/null; then
        print_step "Searching for Flatpak updates..."
        flatpak update -y
        print_step "Cleaning up..."
        flatpak remove --unused -y
      fi

      if command -v brew &>/dev/null; then
        print_step "Searching for Homebrew updates..."
        brew update
        print_step "Cleaning up..."
        brew cleanup
      fi
    fi
  done

  if [[ "$found_universal_pm" == false ]]; then
    print_warn "No universal package manager was found. Skipping updates."
  fi

  return $?
}
