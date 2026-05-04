# claudezak

Replaces Claude Code's polite spinner verbs and statusline with vulgar alternatives. Two surfaces, two mechanisms:

- **Spinner verbs** (the gerund next to the spinner during requests, e.g. `Crafting...`) — swapped via Claude Code's built-in `spinnerVerbs` setting.
- **Statusline** (the persistent bar at the bottom) — driven by a custom command script that prints a random crude phrase.

Examples:
- Spinner: `Fucking...`, `Pegging...`, `Deepthroating...`
- Statusline: `Fucking your mom...`, `Counting the toys in your ass...`, `Spitroasting the sprint...`

## Install

```bash
git clone https://github.com/code-418dotcom/claudezak.git
cd claudezak
./install.sh              # user-wide → ~/.claude/settings.json
./install.sh --project /path/to/repo   # project-scoped
./install.sh --uninstall  # remove (add --project for project scope)
./install.sh --dry-run    # preview the merged settings.json
```

The installer:

- merges `spinnerVerbs` and `statusLine` into the target `settings.json` via `jq` (other settings are preserved);
- copies `bin/claudezak-status.sh` to `~/.claude/bin/` (user) or `<project>/bin/` (project), `chmod +x`;
- backs up `settings.json` as `settings.json.bak.<timestamp>` before any change;
- is safe to re-run.

Requires `jq` on PATH. Restart Claude Code after install.

### Manual install

If you'd rather not run the script:

**1. Spinner verbs** — add to `.claude/settings.json` (project) or `~/.claude/settings.json` (user-wide):

```json
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": ["Fucking", "Sucking", "Ramming", "Pounding", "..."]
  }
}
```

`mode: "replace"` uses only your verbs. `mode: "append"` mixes them with the defaults. Copy the full verb list from this project's `.claude/settings.json`.

**2. Statusline** — copy `bin/claudezak-status.sh` somewhere stable (e.g. `~/.claude/bin/`), `chmod +x` it, then:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/absolute/path/to/claudezak-status.sh"
  }
}
```

Restart Claude Code after either change.

## Customising

- **Spinner verbs**: edit the `spinnerVerbs.verbs` array in `settings.json`. Any string passes — single, two, or three-word gerunds all work (defaults are single-token, hyphenated for compounds).
- **Statusline templates**: edit the `templates=( ... )` array in `bin/claudezak-status.sh`. Use `%p` (project), `%b` (git branch), `%m` (short model name), `%c` (session cost). Cost-bearing templates are appended automatically when Claude Code provides a cost field.

## How it works

- Spinner verbs use Claude Code's documented `spinnerVerbs` setting (schema: `{mode: "append"|"replace", verbs: string[]}`). On each request, Claude Code picks one verb at random.
- The statusline is a shell command Claude Code re-runs on activity, piping session JSON (model, cwd, cost, transcript path) on stdin. The script extracts model/project/branch/cost via `jq`, picks a random vulgar template, and substitutes the fields in.

Requires `jq` and `git` on PATH (both standard on most dev machines).

## Caveats

- The statusline does show real session info (model, project name, git branch, cost) — just wrapped in vulgar templates. Examples: `Edging claudezak (main) on Opus`, `Opus has whored itself out for $2.50 in claudezak`. Gimmick + function.
- A `claude update` won't disturb either mechanism — both live in your settings, not in the binary.
