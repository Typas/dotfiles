# Agent Guidelines

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`.

## GitHub Actions

Use these pinned major versions for official actions — do not use older ones:

- `actions/checkout@v6`
- `actions/upload-artifact@v7`
- `actions/download-artifact@v8`

## Shell Scripts

Run `shellcheck` on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
