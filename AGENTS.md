# Agent Guidelines

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`.

## Branching Rules

To protect `master`, follow these rules:

- When developing any OS-specific bootstrap, check out to a `bootstrap/<name>` branch (e.g., `bootstrap/ubuntu`). Long-lived.
- When developing any recipe, check out to a `dev/<name>` branch (e.g., `dev/zsh`). Long-lived.
- When writing or updating documentation, check out to a `docs/<name>` branch (e.g., `docs/readme`) to avoid merge conflicts with parallel code work. Short-lived. Only `*.md` and `*.org` files may change.
- When updating CI config under `.github/**`, check out to a `ci/<name>` branch (e.g., `ci/branch-policy`). Short-lived. Only files under `.github/**` and `*.md`/`*.org` may change.
- Any other branch name is rejected by the `policy` status check on PRs to `master`.
- Never commit directly to `master`. All changes must land via a pull request.
- Do not merge PRs or delete branches automatically. Merging a PR and deleting the source branch are human-triggered actions.

## GitHub Actions

Use these pinned major versions for official actions — do not use older ones:

- `actions/checkout@v6`
- `actions/upload-artifact@v7`
- `actions/download-artifact@v8`

## Shell Scripts

Run `shellcheck` on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
