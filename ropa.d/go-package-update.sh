#!/usr/bin/env bash

# File        : go-package-update.sh
# Description : Module for updating the Go developer toolchain (ROPA)
# Copyright   : (c) 2025, Gergely Szabo
# License     : MIT
#
# THIS FEATURE IS EXPERIMENTAL AND MAY NOT WORK AS EXPECTED!
#
# The script currently only supports non-root installations, for example: ~/go
# or ~/.local/share/go.
#
# Usage:
#   ropa update|up --go|-g

go_package_update() {
  if command -v go &>/dev/null; then

    # Skip updates if Go is installed to /usr/local/ (officially recommended).
    if [[ "$(command -v go)" == "/usr/local/go/bin/go" ]]; then
      print_warning "Detected system-wide installation of Go toolchain. These are not supported right now, skipping updates."
      return 0
    fi

    print_action "Searching for Go toolchain updates..."

    # Initialize the Go environment variables.
    GO_VERSION="$(go version | awk '{print $3}' | sed 's/go//')"
    GO_INSTALL_DIR="$(command -v go | sed 's|/go.*$||')"
    GO_LATEST_VER="$(curl -s https://go.dev/VERSION?m=text | grep -oP 'go\K[0-9.]+')"

    # Check for updates & download the latest Go version.
    if [[ "$GO_VERSION" == "$GO_LATEST_VER" ]]; then
      print_success "No available Go toolchain updates."
    else
      print_action "Updating Go toolchain..."
      wget "https://go.dev/dl/go$GO_LATEST_VER.linux-amd64.tar.gz" -O /tmp/go.tar.gz

      if [[ $? != 0 ]]; then
        print_error "Failed to download the latest Go version. Please check the output for details."
        return 1
      fi

      # Remove current installation before installing new version.
      rm -rf "$GO_INSTALL_DIR/go" &>/dev/null

      # Install the new Go version.
      tar -C "$GO_INSTALL_DIR" -xzf /tmp/go.tar.gz

      if [[ $? == 0 ]]; then
        print_success "Go toolchain has been updated."
      else
        print_error "Failed to update Go. Please check the output for details."
        return 1
      fi
    fi
  else
    print_warning "Go toolchain is not installed. Skipping updates."
    return 0
  fi

  return $?
}
