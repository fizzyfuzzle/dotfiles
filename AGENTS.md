# AGENTS.md

This repo is a [chezmoi](https://www.chezmoi.io/) source state for dotfiles.

## Rule

Never edit deployed dotfiles directly (`~/.zshrc`, `~/.config/...`). Always
edit the corresponding file in this repo's source state, then apply.

Source state naming: `dot_foo` → `~/.foo`, `private_foo` → deployed with
restricted perms, `*.tmpl` → templated at apply time. See
`chezmoi source-path` on a target to map it back if unsure.

## Layout

- `.chezmoiscripts/` — run_once/run_onchange scripts
- `dot_config/` — → `~/.config/`
- `dot_local/` — → `~/.local/`
- `dot_var/` — → `~/.var/` (e.g. Flatpak VS Code settings)
- `install/` — bootstrap/install scripts
- `.chezmoi.toml.tmpl` — chezmoi config template (source of machine-specific vars)
- `.chezmoiexternal.toml.tmpl` — externally-fetched files (not vendored in repo)
- `.chezmoiignore` — paths excluded from apply
- `dot_zshrc` — → `~/.zshrc`

## Workflow

1. Edit the source file in this repo.
2. `chezmoi diff` — review what would change before touching the target.
3. `chezmoi apply` — deploy.
4. Commit with conventional commits (`feat:`, `fix:`, `chore:`, `refactor:`,
   optional scope).

## Gotchas

- `.chezmoiexternal.toml.tmpl` entries are fetched, not stored here — don't
  try to "find" that content in the repo.
- Templated files (`.tmpl`) render using `.chezmoi.toml.tmpl` vars — check
  before assuming a value is hardcoded.
- Idempotency: scripts under `.chezmoiscripts/` should be safe to re-run.
