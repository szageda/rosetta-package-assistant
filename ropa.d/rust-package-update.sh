#!/usr/bin/env bash

# File        : rust-package-update.sh
# Description : Module for updating the Rust toolchain & environment (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# Usage:
#   ropa update|up --rust|-r

rust_package_update() {
  if command -v rustup &>/dev/null; then
    print_step "Searching for Rust toolchain updates..."

    if [[ $(rustup update 2>/dev/null | wc -l) -gt 3 ]]; then
      print_step "Installing updates..."
      rustup update
    else
      print_info "No available Rust toolchain updates."
    fi

    if command -v cargo &>/dev/null; then
      print_step "Searching for Cargo package updates..."

      # Vanilla Rust doesn't have a "cargo update" equivalent.
      # The method of updating installed packages is using
      # "cargo install" to install the latest available version.
      cargo install $(cargo install --list | \
      grep -E '^[a-z0-9_-]+ v[0-9.]+:$' | \
      cut -f1 -d' ')
    else
      print_err "Cargo is not available: Cannot update packages."
      return 1
    fi
  else
    print_warn "Rust toolchain is not installed. Skipping updates."
  fi

  return $?
}
