# Git worktree workflow

Run [`git-worktree-new`](../private_dot_local/bin/executable_git-worktree-new)
from any worktree in a project, or use `prefix + W` inside tmux. The command
prompts for a task name when none is supplied.

```sh
git-worktree-new feature/my-task
```

By default this creates:

- branch `feature/my-task`
- worktree `../<project>-worktrees/feature-my-task`
- tmux session `<project>-feature-my-task`
- an `nvim` window rooted in the new worktree

The base branch is selected in this order:

1. `origin/dev`
2. `origin/main`
3. `origin/master`
4. local `dev`, `main`, or `master`

The command fetches `origin` first. Use `--base REF` to override selection or
`--no-fetch` when working offline.

## Local files

`.envrc` and `.lazy.lua` are copied from the current worktree when present.
For project-specific ignored files, commit a `.worktree-files` manifest:

```text
# mode path
copy .env
copy .env.local
link config/local-settings.json
```

Paths are relative to the project root. `copy` gives each worktree an
independent file; `link` keeps one shared source file.

## Python

Projects with `uv.lock` or a `[tool.uv]` table run `uv sync`, producing one
`.venv` per worktree.

Other Python projects get a fresh `.venv` via `python3 -m venv`. When the
current worktree has a `.venv`, its packages are seeded into the new
environment by default. This rebuilds from `pip freeze` instead of copying the
virtualenv, avoiding stale absolute paths in scripts. Use `--fresh-venv` to
disable seeding or `--no-python` to skip environment setup.

## TypeScript and Node

Projects with a `package.json` install dependencies in the new worktree. The
package manager is selected from the `packageManager` field first, then from
`pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`/`npm-shrinkwrap.json`, or
`bun.lock`/`bun.lockb`. Projects without either metadata use npm.

Lockfile-based installs use `pnpm install --frozen-lockfile`,
`yarn install --immutable`, `npm ci`, or `bun install --frozen-lockfile`.
Yarn and pnpm fall back to Corepack when their executable is not installed
directly. Use `--no-node` to skip dependency installation.

When the current worktree has `node_modules`, it is cloned or copied into the
new worktree by default. On macOS/APFS, the command first attempts a fast
copy-on-write clone; other filesystems fall back to a regular copy. The package
manager still runs to reconcile the seed with the new worktree. Use
`--fresh-node-modules` to disable seeding.

For seeded npm lockfile projects, the command uses
`npm install --prefer-offline` because `npm ci` always deletes `node_modules`.
Be aware that pnpm already benefits from its shared store, Yarn may use
Plug'n'Play without `node_modules`, and native dependencies can require the
package manager's reconciliation step.

Run `git-worktree-new --help` for path, branch, and tmux overrides.
