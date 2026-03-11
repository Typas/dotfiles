# Agent Guidelines

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

Common types: `feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`.

## Shell Scripts

Run `shellcheck` on any shell script that is added or modified.

- **Error / Warning**: fix before committing.
- **Info**: ask the user whether to fix.
