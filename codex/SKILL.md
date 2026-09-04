---
name: ai-skill-bridge
display_name: AI Skill 跨工具分发
display_name_en: AI Skill Bridge
version: 1.0.0
description: Port AI coding assistant skills/rules across tools — Hermes, Claude Code, Codex, Cursor, OpenClaw. Format specs, directory conventions, and conversion checklist.
description_zh: 在 AI 编程工具之间迁移与分发 skill/规则——覆盖 Hermes、Claude Code、Codex、Cursor、OpenClaw 的格式规范、目录约定与转换清单。
description_en: Port AI coding assistant skills/rules across tools — Hermes, Claude Code, Codex, Cursor, OpenClaw. Format specs, directory conventions, and conversion checklist.
category: devops
tags: [cross-tool, skill-porting, claude-code, codex, cursor, openclaw]
trigger: port skill, sync skill, 分发skill, 多工具同步, install to claude code, install to codex
---

<!-- Usage: Tell Codex "先读 ~/.codex/skills/ai-skill-bridge.md，然后按规范做" -->
<!-- Or add to project AGENTS.md: "For skill porting, read ~/.codex/skills/ai-skill-bridge.md" -->

# Cross-Tool Skill Distribution

Port AI coding assistant skills/rules across tools. Each tool has its own format, directory, and delivery mechanism.

## Tool Format Specs

### Hermes — `~/.hermes/skills/`

- **Location:** `~/.hermes/skills/<category>/<name>/SKILL.md` (global)
- **Trigger:** Auto-loaded by skill name, or explicit `skill_view(name)`
- **Format:** YAML frontmatter (`name`, `description`, `trigger`, `tags`, `category`) + markdown body
- **Naming:** Directory name = skill name, kebab-case

### Claude Code — `~/.claude/commands/`

- **Location:** `~/.claude/commands/<name>.md` (global), `.claude/commands/<name>.md` (project)
- **Trigger:** Slash command `/name` in Claude Code CLI
- **Format:** Pure markdown, NO YAML frontmatter
- **Naming:** Filename = command name, kebab-case

### Codex — `~/.codex/skills/`

- **Location:** `~/.codex/skills/<name>.md` (reference), `AGENTS.md` (project-level)
- **Trigger:** No native command system. Manually referenced or included in `AGENTS.md`
- **Format:** Pure markdown, NO YAML frontmatter

### Cursor — `.cursor/rules/`

- **Location:** `.cursor/rules/<name>.mdc` (project-level) or `.cursorrules` (legacy)
- **Trigger:** Auto-loaded based on glob patterns or always-on
- **Format:** `.mdc` with optional YAML frontmatter (`description`, `globs`, `alwaysApply`)
- **Note:** Project-scoped only, no global equivalent

### OpenClaw — `~/.openclaw/agents/`

- **Location:** `~/.openclaw/agents/main/SOUL.md` (always loaded), standalone `.md` for reference
- **Trigger:** SOUL.md auto-injected; other files explicitly referenced
- **Format:** Pure markdown, NO YAML frontmatter

## Conversion Checklist

1. **Strip source-specific frontmatter** — Remove tool-specific YAML metadata.
2. **Inline referenced files** — Merge `references/`, `templates/`, `scripts/` content into main file.
3. **Keep core instructions intact** — Rules, checklists, patterns, workflows transfer as-is.
4. **Adapt delivery hints** — Add invocation notes for tools without slash commands.
5. **Verify file size** — Keep under ~15KB for Claude Code commands.
6. **Update registry** — Track ports in a central registry.

## Pitfalls

- Do NOT copy YAML frontmatter verbatim — wastes context tokens.
- Codex has no slash commands — reference files manually or via AGENTS.md.
- Keep one source of truth — update canonical version first, then re-port.
