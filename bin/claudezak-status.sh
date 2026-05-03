#!/usr/bin/env bash
# claudezak — profane statusline that actually reflects session state.
# Reads Claude Code's JSON payload on stdin, extracts model/project/branch,
# weaves them into a randomly chosen vulgar template, prints one line.

set -u

input=$(cat)

j() { jq -r "$1" <<<"$input" 2>/dev/null; }

cwd=$(j '.workspace.current_dir // .cwd // ""')
[[ -z "$cwd" || "$cwd" == "null" ]] && cwd="$PWD"

project=$(basename "$cwd" 2>/dev/null)
[[ -z "$project" ]] && project="?"

model_full=$(j '.model.display_name // .model.id // "Claude"')
[[ -z "$model_full" || "$model_full" == "null" ]] && model_full="Claude"
case "$model_full" in
  *Opus*)   model="Opus" ;;
  *Sonnet*) model="Sonnet" ;;
  *Haiku*)  model="Haiku" ;;
  *)        model="$model_full" ;;
esac

branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
fi
[[ -z "$branch" ]] && branch="detached"

cost=$(j '.cost.total_cost_usd // empty')
cost_str=""
if [[ -n "$cost" && "$cost" != "null" ]]; then
  cost_str=$(printf '$%.2f' "$cost" 2>/dev/null)
fi

# Templates use:
#   %p = project name        %b = git branch
#   %m = short model name    %c = cost (may be empty)
templates=(
  "Edging %p (%b) on %m"
  "Railing %p on %m"
  "Pegging %m raw in %p"
  "Riding %m bareback through %p/%b"
  "Plowing %p/%b like a slut"
  "Sucking off %m for tokens in %p"
  "Cumming on %p/%b"
  "Whoring out %m all over %p"
  "%p getting railed by %m"
  "Fucking %p raw on %m"
  "Spitroasting %p (%b) with %m"
  "Drilling %m balls-deep into %p"
  "Choking %m on %p/%b"
  "%p/%b is getting reamed by %m"
  "%m is pegging %p tonight"
  "Bouncing %p on %m's lap"
  "%m wants to fuck %p so bad"
  "Mounting %m in %p's back alley"
  "Tongue-fucking %p with %m"
  "Cock-slapping %p/%b until it compiles"
)

# If we have cost, occasionally use a cost-bearing template
if [[ -n "$cost_str" ]]; then
  templates+=(
    "Edging %p on %m — already spent %c on this session"
    "%c worth of %m railing %p"
    "%m has whored itself out for %c in %p"
    "Pounding %p/%b — %c down the drain"
  )
fi

idx=$(( RANDOM % ${#templates[@]} ))
out="${templates[$idx]}"
out="${out//%p/$project}"
out="${out//%b/$branch}"
out="${out//%m/$model}"
out="${out//%c/$cost_str}"

printf '%s\n' "$out"
