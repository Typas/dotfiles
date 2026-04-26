# Emacs & Neovim Install Routing Design

**Date:** 2026-04-25
**Branch:** dev/emacs
**Scope:** `scripts/install-emacs.sh`, `scripts/install-neovim.sh`

## Problem

Both install scripts currently route openSUSE Tumbleweed through source-build or binary-download paths that require extra dependencies and take longer than necessary in CI. The desired routing is consistent across both scripts: package manager for distros that ship a good enough package, native package install for the three target distros, nix for mac.

Additionally, `install-emacs.sh` currently builds from source for debian/fedora/ubuntu, which is too slow for CI iteration on `dev/emacs`.

## Goal

Apply a uniform distro routing to both scripts:

| distro                      | method                        |
|-----------------------------|-------------------------------|
| mac                         | nix (unchanged)               |
| cachyos                     | pacman (unchanged)            |
| opensuse-tumbleweed         | zypper (new for both scripts) |
| debian/ubuntu (system)      | install .deb from releases    |
| fedora (system)             | install .rpm from releases    |
| debian/fedora/ubuntu (home) | source build (emacs only)     |

---

## `install-emacs.sh`

### Package assets

| distro | asset name                               | install command                   |
|--------|------------------------------------------|-----------------------------------|
| ubuntu | `emacs-typas_<version>_ubuntu_amd64.deb` | `sudo apt-get install -y ./<pkg>` |
| debian | `emacs-typas_<version>_debian_amd64.deb` | `sudo apt-get install -y ./<pkg>` |
| fedora | `emacs-typas-<version>-1.x86_64.rpm`     | `sudo dnf install -y ./<pkg>`     |

`$os` maps directly into the deb filename (`ubuntu`/`debian`). The rpm has no distro tag.

Version is resolved by querying `https://api.github.com/repos/Typas/emacs-build/releases/latest` and parsing `tag_name` with `grep`/`sed`. Strip any leading `v` from the tag to match package filenames.

### `install_package` function

1. Query releases API, parse version from `tag_name` (strip leading `v`)
2. Construct asset filename and download URL based on `$os`
3. Download to `/tmp/` via `curl -fsSL`
4. Install with the distro-appropriate command (see table above)
5. Remove `/tmp` package file
6. Verify with `emacs --version | head -1`

### Action coverage

| action  | location | debian/ubuntu         | fedora                | mac | cachyos | opensuse  |
|---------|----------|-----------------------|-----------------------|-----|---------|-----------|
| install | system   | install_package (deb) | install_package (rpm) | nix | pacman  | zypper in |
| install | home     | do_build (source)     | do_build (source)     | —   | —       | —         |
| update  | system   | install_package (deb) | install_package (rpm) | nix | pacman  | zypper up |
| update  | home     | do_build (source)     | do_build (source)     | —   | —       | —         |

`home` falls back to source build because packages always install to system paths.

### Cleanup

- Add zypper early-exit block after the CachyOS block
- Remove the `opensuse-tumbleweed` branch from `ensure_build_deps` (dead code)
- Remove `download_binary` / tarball logic (replaced by `install_package`)
- Remove zstd dependency (no longer needed)

---

## `install-neovim.sh`

Neovim already downloads a self-contained binary tarball from upstream (`neovim/neovim` releases) for debian/fedora/ubuntu in both system and home locations. The only change is adding the zypper early-exit for openSUSE Tumbleweed.

### Action coverage

| action  | location | debian/fedora/ubuntu         | mac | cachyos | opensuse  |
|---------|----------|------------------------------|-----|---------|-----------|
| install | system   | do_install (upstream binary) | nix | pacman  | zypper in |
| install | home     | do_install (upstream binary) | —   | —       | —         |
| update  | system   | do_install (upstream binary) | nix | pacman  | zypper up |
| update  | home     | do_install (upstream binary) | —   | —       | —         |

`home` keeps binary download because the neovim tarball is not prefix-baked.

### Cleanup

- Add zypper early-exit block after the CachyOS block
- Remove the `opensuse-tumbleweed` branch from `ensure_runtime_deps` (dead code)

---

## CI coverage

`just emacs` and `just neovim` (no arguments) → `install action=install location=""` → defaults to `system`. Only the install action is tested in CI.

## Out of scope

- ARM / other architectures
- `home` binary installs for emacs (binary compiled against `/usr/local`)
