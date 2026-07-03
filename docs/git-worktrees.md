# Git worktree workflow

Run [`git-worktree-new`](../private_dot_local/bin/executable_git-worktree-new)
from any worktree in a project, or use `prefix + W` inside tmux. The command
prompts for a task name when none is supplied.

```sh
git-worktree-new feature/my-task
```

By default this creates:

- branch `wt/feature/my-task`
- worktree `../<project>-worktrees/<project>-feature-my-task`
- tmux session `<project>-worktree-feature-my-task`
- an `nvim` window rooted in the new worktree

In Lazygit's worktrees panel, press `T` to open the selected worktree's tmux
session. This calls
[`tmux-worktree-open`](../private_dot_local/bin/executable_tmux-worktree-open),
which creates the standard `nvim` session when it does not already exist and
then switches to it. This recreates sessions after a restart without restoring
tmux server state.

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

For other Python projects, the current worktree's `.venv/bin/python` creates
the new `.venv`, keeping the Python implementation and version aligned. Its
`purelib` and `platlib` site-packages are then cloned or copied into the new
environment by default. On macOS/APFS this first attempts a copy-on-write
clone. This avoids dependency resolution and preserves complex or locally
built packages.

Only site-packages are copied, not the source venv's `bin` scripts, because
those scripts contain absolute shebang paths. Package entry-point commands may
therefore need regeneration with the project's normal install command. Also
check editable-install `.pth` files, which may reference the source worktree.
Use `--fresh-venv` to disable package copying or `--no-python` to skip
environment setup.

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

## DVC

Projects with a `.dvc` directory automatically reuse the source worktree's
effective DVC cache. The command writes the absolute cache path to the new
worktree's Git-ignored `.dvc/config.local` and uses `reflink,copy` on macOS.

Data is not materialized by default, keeping worktree creation fast for tasks
that do not use DVC outputs. Pass `--dvc-checkout` to run `dvc checkout` from
the existing local cache. The command deliberately does not run `dvc pull`; if
an object is missing, checkout fails instead of starting an unexpected
download. Use `--no-dvc` to skip shared-cache configuration entirely.

All worktrees depend on the shared cache, so use `dvc gc` carefully.

Run `git-worktree-new --help` for path, branch, and tmux overrides.
