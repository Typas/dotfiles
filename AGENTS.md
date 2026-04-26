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
- Any other branch name is rejected by the `policy` status check on PRs to `master`.
- Never commit directly to `master`. All changes must land via a pull request.
- Do not open, merge, or auto-close PRs, or delete branches. These are human-triggered actions.
- Short-lived branches (`docs/*`, `ci/*`) should be deleted by a human after their PR merges. Long-lived branches (`bootstrap/*`, `dev/*`) must be kept.
- Do not reuse long-lived branch names (`bootstrap/*`, `dev/*`) for throwaway test pushes. If a verification probe must push to such a name, land a revert commit after the probe PR is closed — do not force-reset or delete the branch.
- Before editing, `git fetch` and fast-forward the target branch. Long-lived branches may have advanced since last local sync.
- Never `git commit --amend` a pushed commit and never `git push --force` (including `--force-with-lease`). If a pushed commit needs fixing, add a follow-up commit or open a new branch.

## GitHub Actions

Use these pinned major versions for official actions — do not use older ones:

- `actions/checkout@v6`
- `actions/upload-artifact@v7`
- `actions/download-artifact@v8`

## Shell Scripts

Run `shellcheck` on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
