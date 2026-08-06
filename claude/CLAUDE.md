# Global Claude Configuration

## Memory location

Auto-memory files live at `~/.claude-memory/<encoded-project-path>/`, **not** inside
`~/.claude/projects/`. The per-project `memory/` path is a symlink pointing there.

Keep writing to the `memory/` path given in the session prompt — the symlink resolves it.
Do not replace the symlink with a real directory, and do not copy memory files back into
`~/.claude/projects/`.

Why: `~/.claude/projects/` holds session transcripts and gets deleted to reclaim space or
clear history. Memory used to live inside it, so a cleanup would silently destroy it.
