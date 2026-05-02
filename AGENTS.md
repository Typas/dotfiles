# Agent Guidelines

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`.

## Branching Rules

To protect `master`, follow these rules:

- When developing any OS-specific bootstrap, check out to a `bootstrap/<name>` branch (e.g., `bootstrap/ubuntu`). Long-lived. Scope is restricted by `branch-policy`:
  - `bootstrap/<distro>` (where `<distro>` is `ubuntu`, `debian`, `fedora`, `opensuse-tumbleweed`, or `cachyos`): only `os-init/<distro>-init.sh` and `.github/actions/linux-container-setup/**` (plus `*.md`/`*.org`).
  - `bootstrap/mac`: only `flake.nix`, `flake.lock`, `nix/**`, `hosts/**`, and `.github/actions/mac-nix-setup/**` (plus `*.md`/`*.org`).
  - `bootstrap/shared`: only `init.sh` and `scripts/shell-init.sh` (plus `*.md`/`*.org`). This is the only bootstrap branch whose PR triggers the full `bootstrap.yml` matrix — use it for edits that affect bootstrap across all distros.
- When developing any recipe, check out to a `dev/<name>` branch (e.g., `dev/zsh`). Long-lived.
- When writing or updating documentation, check out to a `docs/<name>` branch (e.g., `docs/readme`) to avoid merge conflicts with parallel code work. Short-lived. Only `*.md` and `*.org` files may change.
- When updating CI config under `.github/**`, check out to a `ci/<name>` branch (e.g., `ci/branch-policy`). Short-lived. Only files under `.github/**` and `*.md`/`*.org` may change.
- For cross-cutting changes that cannot fit any other prefix (e.g., renaming files across multiple scopes), check out to an `unsafe/<name>` branch. Short-lived. No file-scope restriction — analogous to Rust's `unsafe`, requires extra scrutiny on review.
- Any other branch name is rejected by the `policy` status check on PRs to `master`.
- Never commit directly to `master`. All changes must land via a pull request.
- Do not open, merge, or auto-close PRs, or delete branches. These are human-triggered actions.
- Short-lived branches (`docs/*`, `ci/*`, `unsafe/*`) should be deleted by a human after their PR merges. Long-lived branches (`bootstrap/*`, `dev/*`) must be kept.
- Do not reuse long-lived branch names (`bootstrap/*`, `dev/*`) for throwaway test pushes. If a verification probe must push to such a name, land a revert commit after the probe PR is closed — do not force-reset or delete the branch.
- Before editing, `git fetch`, fast-forward the target branch (long-lived branches may have advanced since last local sync), and rebase it onto `master` so it picks up recent changes.
- Never `git commit --amend` a pushed commit. Never `git push --force` (including `--force-with-lease`), **except** when force-pushing a long-lived branch after rebasing it onto `master`. If a pushed commit needs fixing for any other reason, add a follow-up commit or open a new branch.

## GitHub Actions

Use these pinned major versions for official actions — do not use older ones:

- `actions/checkout@v6`
- `actions/upload-artifact@v7`
- `actions/download-artifact@v8`

## Smoke Testing

When working on a `dev/*` branch, verify the CI smoke test passes for all relevant targets. The workflow (`recipe.yml`) runs bootstrap + recipe installation across: `ubuntu`, `mac`, `fedora-44`, `fedora-43`, `cachyos`, `opensuse-tumbleweed`, and `debian-trixie`.

To inspect failures:

```sh
gh run view <run-id> --log-failed
```

Fix the recipe and push a follow-up commit until all targets pass.

The CI only checks that `just <recipe>` exits 0, not that the binary works. If the justfile target lacks a verification command (e.g., `emacs --version`), add one.

## Shell Scripts

Run `shellcheck` on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
