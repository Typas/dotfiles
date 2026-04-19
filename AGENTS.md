# Agent Guidelines

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`.

## Branching Rules

To protect `master`, follow these rules:

- When developing any OS-specific bootstrap, check out to a `bootstrap/<name>` branch (e.g., `bootstrap/ubuntu`).
- When developing any recipe, check out to a `dev/<name>` branch (e.g., `dev/zsh`).
- When writing or updating documentation, check out to a `docs/<name>` branch (e.g., `docs/readme`) to avoid merge conflicts with parallel code work.
- Never commit directly to `master`. All changes must land via a pull request.

## GitHub Actions

Use these pinned major versions for official actions — do not use older ones:

- `actions/checkout@v6`
- `actions/upload-artifact@v7`
- `actions/download-artifact@v8`

## Shell Scripts

Run `shellcheck` on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
