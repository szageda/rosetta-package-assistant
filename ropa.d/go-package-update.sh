#!/usr/bin/env bash

# File        : go-package-update.sh
# Description : Module for updating the Go developer toolchain (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# The script currently only supports non-root installations, for example: ~/go
# or ~/.local/share/go.
#
# Usage:
#   ropa update|up --go|-g

go_package_update() {
  # Fail silenty if called via 'ropa update --full'.
  if [[ "$option" == "--full" || "$option" == "-f" ]]; then
    return 0
  fi

  if command -v go &>/dev/null; then
    if [[ "$(command -v go)" == "/usr/local/go/bin/go" ]]; then
      print_warn "Detected system-wide installation of Go toolchain. These are not supported right now, skipping updates."
      return 0
    fi

    GO_VERSION="$(go version | awk '{print $3}' | sed 's/go//')"
    GO_INSTALL_DIR="$(command -v go | sed 's|/go.*$||')"
    GO_LATEST_VER="$(curl -s https://go.dev/VERSION?m=text | grep -oP 'go\K[0-9.]+')"

    print_step "Searching for Go toolchain updates..."
    if [[ "$GO_VERSION" == "$GO_LATEST_VER" ]]; then
      print_info "No available Go toolchain updates."
    else
      print_step "Updating Go toolchain..."
      wget "https://go.dev/dl/go$GO_LATEST_VER.linux-amd64.tar.gz" -O /tmp/go.tar.gz

      if [[ $? != 0 ]]; then
        print_err "Failed to download the latest Go version. Please check the output for details."
        return 1
      fi

      # Remove current installation before installing the new version.
      rm -rf "$GO_INSTALL_DIR/go" &>/dev/null
      tar -C "$GO_INSTALL_DIR" -xzf /tmp/go.tar.gz

      if [[ $? == 0 ]]; then
        print_info "Go toolchain has been updated."
      else
        print_err "Failed to update Go. Please check the output for details."
        return 1
      fi
    fi
  else
    print_warn "Go toolchain is not installed. Skipping updates."
    return 0
  fi

  return $?
}
