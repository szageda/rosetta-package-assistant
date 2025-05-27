#!/usr/bin/env bash

# File        : rust-package-update.sh
# Description : Module for updating the Rust toolchain & environment (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
# 
# The function checks if the Rust toolchain (rustup) is executable on the
# system. If it is, it updates the toolchain, and subsequently checks for
# the exectuability of Cargo, the Rust package manager. If Cargo is available,
# it updates all installed Cargo packages.
#
# Usage:
#   This function must be called from ropa() to be executed.
#     ropa update|up --rust|-r

rust_package_update() {
  if command -v rustup &>/dev/null; then
    print_header "Updating Rust Packages"

    if [[ $(rustup update 2>/dev/null | wc -l) -gt 3 ]]; then
      print_action "Updating Rust toolchain..."
      rustup update
      print_success "Rust toolchain has been updated."
    else
      print_success "No available Rust toolchain updates."
    fi

    if command -v cargo &>/dev/null; then
      print_action "Updating Cargo packages..."

      # Vanilla Rust doesn't have a "cargo update" equivalent.
      # The method of updating installed packages is using
      # "cargo install" to install the latest available version.
      cargo install $(cargo install --list | \
      grep -E '^[a-z0-9_-]+ v[0-9.]+:$' | \
      cut -f1 -d' ')
      print_success "Cargo packages have been updated."
    else
      print_error "Cargo is not available: Cannot update packages."
      return 1
    fi
  else
    print_warning "Rust toolchain is not installed. Skipping updates."
  fi

  return $?
}