# Agent Guidelines

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`.

## Branching Rules

**Before touching any file: pick the branch prefix, derive the name, check it out.** Editing on `master` is forbidden — no exceptions.

| Prefix               | When                                                                      | `<name>` rule                                                                  | Allowed files                                                                                       |
|----------------------|---------------------------------------------------------------------------|--------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `bootstrap/<distro>` | OS bootstrap (`ubuntu` `debian` `fedora` `opensuse-tumbleweed` `cachyos`) | distro name exactly                                                            | `os-init/<distro>-init.sh`, `.github/actions/linux-container-setup/**`, `*.md`/`*.org`              |
| `bootstrap/mac`      | macOS bootstrap                                                           | `mac` exactly                                                                  | `flake.nix`, `flake.lock`, `nix/**`, `hosts/**`, `.github/actions/mac-nix-setup/**`, `*.md`/`*.org` |
| `bootstrap/shared`   | cross-distro bootstrap                                                    | `shared` exactly                                                               | `init.sh`, `scripts/shell-init.sh`, `justfile`, `*.md`/`*.org`                                      |
| `dev/<recipe>`       | recipe work                                                               | must be a public recipe in `justfile` — check with `just --list` before naming | recipe scripts; no bootstrap-scope paths                                                            |
| `docs/<stem>`        | docs only                                                                 | stem of the primary file changed (e.g. `agents` for `AGENTS.md`)               | `*.md`, `*.org`                                                                                     |
| `ci/<stem>`          | CI config                                                                 | stem of the workflow/action file changed                                       | `.github/**`, `*.md`/`*.org`                                                                        |
| `unsafe/<name>`      | **last resort** — change spans scopes and **cannot be split**             | descriptive                                                                    | anything                                                                                            |

`unsafe` is not a catch-all. If a task touches multiple recipes, use one `dev/<recipe>` branch per recipe. Only use `unsafe` when splitting is genuinely impossible.

- Never commit directly to `master`. All changes must land via PR.
- Do not open, merge, close PRs, or delete branches — human actions only.
- Before editing: `git pull` on `master`, checkout the target branch, then `git merge master` to bring it up to date. Push with a plain `git push`.
- Never amend a pushed commit. Never force-push. Keep branches current by merging `master` in, not rebasing. Fix pushed commits with a follow-up commit instead.

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

## Command Chaining

- `git commit` must always run alone — never chain it with other commands.
- All other command chains are limited to 2 commands maximum.

## Available Tools

`fd` and `rg` are available as standard search tools. Prefer them over `find` and `grep`.

## Shell Scripts

Run `shellcheck -x` from the script's directory on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
