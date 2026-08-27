# Global Claude Configuration

## Response Style

Be concise and focused, for every model. Skip non-essential context and background restatement. Keep code examples minimal — just enough to make the point, not full working files unless asked. Lead with the answer/result, not the reasoning trail.

## Opus 5 Effort

Default to `medium` effort for routine work. Before switching to `xhigh` effort or invoking ultracode/multi-agent workflow orchestration, ask for permission first and state why the task needs it (large blast radius, exhaustive search, high-stakes correctness) — don't switch unprompted just because a task looks hard.

## Security

- Never read, print, or commit secrets (`.env*`, credentials, private keys, tokens). If a task seems to require it, stop and ask.
- Proactively flag potential security issues you notice while working, even outside the current task's scope — don't fix them unasked, just surface them.

## Memory location

Auto-memory files live at `~/.claude-memory/<encoded-project-path>/`, **not** inside
`~/.claude/projects/`. The per-project `memory/` path is a symlink pointing there.

Keep writing to the `memory/` path given in the session prompt — the symlink resolves it.
Do not replace the symlink with a real directory, and do not copy memory files back into
`~/.claude/projects/`.

Why: `~/.claude/projects/` holds session transcripts and gets deleted to reclaim space or
clear history. Memory used to live inside it, so a cleanup would silently destroy it.
