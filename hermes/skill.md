---
name: ai-skill-bridge
description: Port AI coding assistant skills/rules across tools — Hermes, Claude Code, Codex, Cursor, OpenClaw. Format specs, directory conventions, and conversion checklist.
category: devops
tags: [cross-tool, skill-porting, claude-code, codex, cursor, openclaw]
trigger: port skill, sync skill, 分发skill, 多工具同步, install to claude code, install to codex
---

# Cross-Tool Skill Distribution

Port AI coding assistant skills/rules across tools. Each tool has its own format, directory, and delivery mechanism.

---

## Tool Format Specs

### Hermes — `~/.hermes/skills/`

- **Location:** `~/.hermes/skills/<category>/<name>/SKILL.md` (global)
- **Trigger:** Auto-loaded by skill name in conversation, or explicit `skill_view(name)`
- **Format:** YAML frontmatter (`name`, `description`, `trigger`, `tags`, `category`) + markdown body
- **Content:** SKILL.md is the main file; optional `references/`, `templates/`, `scripts/` subdirectories
- **Naming:** Directory name = skill name. Use kebab-case (e.g., `ai-skill-bridge`)

### Claude Code — `~/.claude/commands/`

- **Location:** `~/.claude/commands/<name>.md` (global), `.claude/commands/<name>.md` (project)
- **Trigger:** Slash command `/name` in Claude Code CLI
- **Format:** Pure markdown, NO YAML frontmatter
- **Content:** The entire `.md` file is injected as system instructions when the command is invoked
- **Naming:** Filename = command name. Use kebab-case (e.g., `ai-skill-bridge.md` → `/ai-skill-bridge`)

### Codex — `~/.codex/skills/`

- **Location:** `~/.codex/skills/<name>.md` (reference), `AGENTS.md` (project-level injection)
- **Trigger:** No native command system. Must be manually referenced in conversation or included in `AGENTS.md`
- **Format:** Pure markdown, NO YAML frontmatter
- **Content:** Standalone instruction file that can be read by Codex when referenced
- **Usage patterns:**
  - Tell Codex: "先读 ~/.codex/skills/ai-skill-bridge.md，然后按规范做"
  - Or add to project `AGENTS.md`: `For skill porting, read ~/.codex/skills/ai-skill-bridge.md`

### Cursor — `.cursor/rules/`

- **Location:** `.cursor/rules/<name>.mdc` (project-level, newer) or `.cursorrules` (project root, legacy)
- **Trigger:** Auto-loaded based on file glob patterns or always-on
- **Format:** `.mdc` files with optional YAML frontmatter (`description`, `globs`, `alwaysApply`)
- **Note:** Cursor rules are project-scoped only, no global equivalent

### OpenClaw — `~/.openclaw/agents/`

- **Location:** `~/.openclaw/agents/main/SOUL.md` (agent persona, always loaded), standalone `.md` files for reference
- **Trigger:** SOUL.md is auto-injected into every session; other files must be explicitly referenced
- **Format:** Pure markdown, NO YAML frontmatter
- **Content:** SOUL.md defines identity and boundaries; supplementary skill files can be referenced from SOUL.md or mentioned in conversation
- **Usage patterns:**
  - Add to SOUL.md: `For skill porting rules, read ~/.openclaw/skills/ai-skill-bridge.md`
  - Or tell OpenClaw: "先读 ai-skill-bridge.md，然后按规范做"

---

## Conversion Checklist

When porting a skill across tools:

1. **Strip source-specific frontmatter** — Remove YAML blocks that are tool-specific metadata (e.g., Hermes `trigger`, `tags`; Cursor `globs`, `alwaysApply`). These don't transfer.
2. **Inline referenced files** — If the source skill references `references/`, `templates/`, `scripts/` subdirectories, inline the critical content into the main file. Most tools only support a single file.
3. **Keep core instructions intact** — All design rules, audit checklists, forbidden patterns, and workflow steps transfer as-is.
4. **Adapt delivery hints** — For tools without slash commands (Codex, OpenClaw), add a note at the top about how to invoke the skill.
5. **Verify file size** — Claude Code commands should stay under ~15KB to avoid context window bloat.
6. **Update registry** — Track which skills have been ported to which tools in a central registry file.

---

## Pitfalls

- **Do NOT copy YAML frontmatter verbatim across tools** — Claude Code and Codex will render it as visible text, wasting context tokens.
- **Codex/OpenClaw have no slash commands** — Users must manually tell the tool to read the skill file, or embed the reference in AGENTS.md / SOUL.md.
- **Claude Code commands are global OR project** — `~/.claude/commands/` is global (all projects), `.claude/commands/` is project-only. Default to global for reusable skills.
- **Cursor rules are project-only** — No global equivalent. Skills must be copied into each project's `.cursor/rules/` directory.
- **Keep one source of truth** — When updating, always update the canonical version first, then re-port. Don't maintain divergent copies.
- **OpenClaw SOUL.md is for persona** — Don't dump entire skill files into SOUL.md. Reference them instead.
