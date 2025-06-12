# Rosetta Package Assistant

**ROPA** – **RO**setta **P**ackage **A**ssistant – is not a package manager. It acts as a unified front-end wrapper for GNU/Linux distributions providing a consistent and simplified command-line interface, allowing you to manage your system's packages without needing to remember the specific syntax for each underlying package manager.

**Supported Package Managers**

- System package managers: APT, DNF, Zypper.
- Universal package managers: Snaps, Flatpak, Homebrew.
- Rust toolchain & Cargo package manager.

## Installation

1. Clone the repository to your computer.

```shell
git clone --single-branch --depth 1 https://github.com/szageda/rosetta-package-assistant.git ~/.local/bin
```

2. Source `ropa.sh` in your `.bashrc`.

```shell
echo -e '\nsource $HOME/.local/bin/ropa.sh' >> ~/.bashrc
```

3. Reload your shell environment.

```shell
source ~/.bashrc
```

## Usage & Syntax

```shell
$ ropa [COMMAND...] [OPTION...] <package...>
```

Run `ropa -h` or `ropa --help` to get a full overview of available commands and options.
