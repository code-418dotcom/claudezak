# Memory

## Now
- claudezak v1 shipped: spinner verbs + statusline both replaced with profane variants.

## Project Profile
- Type: Claude Code customisation / gimmick
- Language: Bash (statusline script) + JSON (settings)
- Framework: none

## Open Threads
- Spinner verbs are single-word gerunds; statusline is multi-word phrases. Two separate lists living in different places.

## Recent Decisions
- 050226 — Use built-in `spinnerVerbs` setting (`{mode, verbs}`) instead of patching `claude.exe`. Code path: `t2H()` reads `x6().spinnerVerbs`. Zero binary modification. Survives `claude update`.
- 050226 — Statusline rewritten to show real session info (model/project/branch/cost) wrapped in profane templates. Uses `jq` for safe JSON parsing.
- 050226 — Wired into `~/projects/new.sh` so every Claudify-bootstrapped project inherits claudezak by default (interactive prompt, jq-merge into target settings).

## Blockers
- (none)

## Key Facts
- Claude Code installs as a Bun-compiled ELF binary at `/home/sjanus/.npm-global/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe` (~237MB).
- `spinnerVerbs.mode = "replace"` overrides the default verb pool entirely; `"append"` concats.
- Default verbs (for reference) start: `Accomplishing, Actioning, Actualizing, Architecting, Baking, Beaming, Beboppin', ...` ~100+ entries.
