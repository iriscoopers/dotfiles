#!/usr/bin/env bash
#
# Sync an already installed dotfiles setup with this repo:
#   * creates symlinks that are missing
#   * repoints symlinks that aim at the wrong file
#   * removes obsolete symlinks (links into this repo whose source is gone)
#
# Only symlinks pointing back into this repo are ever removed, so unrelated
# files in $HOME are left alone. Safe to run repeatedly.
#
# Usage: scripts/update.sh [--dry-run]

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

DRY_RUN=0
case "${1:-}" in
  -n|--dry-run) DRY_RUN=1 ;;
  "") ;;
  *) echo "Usage: $(basename "$0") [--dry-run]" >&2; exit 64 ;;
esac

# Source -> destination map, "<path relative to repo>|<destination>".
# Directories are mirrored: real directories in the destination, files inside
# them symlinked individually, so obsolete files can be pruned one by one.
LINKS="\
ack|$HOME
vim|$HOME
tmux|$HOME
git|$HOME
shell|$HOME
config|$HOME/.config
alacritty|$HOME/.config/alacritty
claude/statusline.sh|$HOME/.claude/statusline.sh
claude/CLAUDE.md|$HOME/.claude/CLAUDE.md"

# Destination paths that get a different name than their source.
RENAMES="\
$HOME/git_template|$HOME/.git_template"

# Basenames that are never symlinked.
EXCLUDE_RE='^(\.DS_Store|\.git|.*\.itermcolors|.*\.itermkeymap|.*iterm.*\.json)$'

# Paths (relative to the repo) that are copied by install.sh rather than
# symlinked, so machine-local edits stay out of the repo. If a previous run
# symlinked one of these, it is converted back to a real copy.
#
# git_template/HEAD must be a real file: git refuses to clone when the template
# directory's HEAD is a symlink, failing with "fatal: --stdin requires a git
# repository" on every clone on the machine.
COPY_NOT_LINK="git/.gitconfig
git/git_template/HEAD"

created=0; relinked=0; removed=0; ignored=0; converted=0
desired=""       # newline separated destination paths we want to exist
managed_dirs=""  # newline separated destination directories we mirror into

log() { printf '%s\n' "$*"; }
run() { if [ "$DRY_RUN" -eq 1 ]; then log "    would run: $*"; else "$@"; fi; }

apply_rename() {
  local dest="$1" line
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    if [ "$dest" = "${line%%|*}" ]; then printf '%s' "${line#*|}"; return; fi
  done <<< "$RENAMES"
  printf '%s' "$dest"
}

is_copy_not_link() {
  local rel="$1" line
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    [ "$rel" = "$line" ] && return 0
  done <<< "$COPY_NOT_LINK"
  return 1
}

# A file we deliberately do not symlink. If an earlier run linked it, turn the
# link back into a real copy so local edits are possible again; otherwise leave
# whatever is there alone.
keep_as_copy() {
  local src="$1" dest="$2"
  desired="$desired$dest"$'\n'   # keep prune from reclaiming it
  if [ -L "$dest" ] && case "$(readlink "$dest")" in "$DOTFILES_DIR"/*) true ;; *) false ;; esac; then
    log "= $dest is copied, not linked - replacing old symlink with a real copy"
    run rm -f "$dest"
    run cp "$src" "$dest"
    converted=$((converted + 1))
  elif [ ! -e "$dest" ]; then
    log "= $dest is copied, not linked - creating initial copy"
    run mkdir -p "$(dirname "$dest")"
    run cp "$src" "$dest"
    converted=$((converted + 1))
  else
    ignored=$((ignored + 1))   # real file already there, leave local edits be
  fi
}

link_file() {
  local src="$1" dest="$2" current
  desired="$desired$dest"$'\n'

  if [ -L "$dest" ]; then
    current="$(readlink "$dest")"
    [ "$current" = "$src" ] && return 0
    log "~ repoint $dest -> $src (was $current)"
    run rm -f "$dest"
    run ln -s "$src" "$dest"
    relinked=$((relinked + 1))
  elif [ -e "$dest" ]; then
    log "! $dest exists as a real file - backed up to $dest.bak"
    run mv "$dest" "$dest.bak"
    run ln -s "$src" "$dest"
    created=$((created + 1))
  else
    log "+ $dest -> $src"
    run mkdir -p "$(dirname "$dest")"
    run ln -s "$src" "$dest"
    created=$((created + 1))
  fi
}

walk() {
  local src_dir="$1" dest_dir="$2" item name dest
  managed_dirs="$managed_dirs$dest_dir"$'\n'
  for item in "$src_dir"/* "$src_dir"/.[!.]*; do
    [ -e "$item" ] || continue          # no match, glob left literal
    name="$(basename "$item")"
    if [[ "$name" =~ $EXCLUDE_RE ]]; then
      ignored=$((ignored + 1))
      continue
    fi
    dest="$(apply_rename "$dest_dir/$name")"
    if is_copy_not_link "${item#$DOTFILES_DIR/}"; then
      keep_as_copy "$item" "$dest"
      continue
    fi
    if [ -d "$item" ]; then
      [ -d "$dest" ] || run mkdir -p "$dest"
      walk "$item" "$dest"
    else
      link_file "$item" "$dest"
    fi
  done
}

is_desired()     { printf '%s' "$desired" | grep -Fxq -- "$1"; }
is_managed_dir() { printf '%s' "$managed_dirs" | grep -Fxq -- "$1"; }

# True if the directory directly contains a symlink pointing into this repo.
# Used to decide whether an unmanaged directory is one we created previously.
holds_repo_link() {
  local dir="$1" item
  for item in "$dir"/* "$dir"/.[!.]*; do
    [ -L "$item" ] || continue
    case "$(readlink "$item")" in "$DOTFILES_DIR"/*) return 0 ;; esac
  done
  return 1
}

prune() {
  local dir="$1" item target
  [ -d "$dir" ] || return 0
  for item in "$dir"/* "$dir"/.[!.]*; do
    [ -e "$item" ] || [ -L "$item" ] || continue
    if [ -L "$item" ]; then
      target="$(readlink "$item")"
      case "$target" in "$DOTFILES_DIR"/*) ;; *) continue ;; esac
      is_desired "$item" && continue
      log "- obsolete $item -> $target"
      run rm -f "$item"
      removed=$((removed + 1))
    elif [ -d "$item" ]; then
      # Descend only into directories we manage or clearly created ourselves,
      # so we never walk unrelated trees under $HOME or ~/.config.
      if is_managed_dir "$item" || holds_repo_link "$item"; then
        prune "$item"
        if [ "$dir" != "$HOME" ] && [ -d "$item" ] && [ -z "$(ls -A "$item" 2>/dev/null)" ]; then
          log "- empty dir $item"
          run rmdir "$item"
        fi
      fi
    fi
  done
}

log "Syncing symlinks from $DOTFILES_DIR"
[ "$DRY_RUN" -eq 1 ] && log "(dry run - nothing will be changed)"
log ""

prune_roots=""
while IFS= read -r entry; do
  [ -n "$entry" ] || continue
  src="$DOTFILES_DIR/${entry%%|*}"
  dest="${entry#*|}"
  if [ ! -e "$src" ]; then
    log "! source missing, skipping: $src"
    continue
  fi
  if [ -d "$src" ]; then
    [ -d "$dest" ] || run mkdir -p "$dest"
    walk "$src" "$dest"
    prune_roots="$prune_roots$dest"$'\n'
  else
    link_file "$src" "$dest"
    prune_roots="$prune_roots$(dirname "$dest")"$'\n'
  fi
done <<< "$LINKS"

log ""
log "Checking for obsolete symlinks"
while IFS= read -r root; do
  [ -n "$root" ] || continue
  prune "$root"
done <<< "$(printf '%s' "$prune_roots" | sort -u)"

log ""
log "Done: $created created, $relinked repointed, $removed removed, $converted copied, $ignored ignored."
[ "$DRY_RUN" -eq 1 ] && log "Re-run without --dry-run to apply."
exit 0
