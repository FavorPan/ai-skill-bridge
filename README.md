# AI Skill Bridge

> **[中文版](README_CN.md)** | One skill, every tool. Port your AI coding assistant skills/rules across Hermes, Claude Code, Codex, Cursor, and OpenClaw.

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Tools: 5](https://img.shields.io/badge/Tools-5-green.svg)

**The problem:** You write a great skill/rule for one AI coding tool, but it's locked into that tool's format. Switch tools? Rewrite from scratch.

**The solution:** AI Skill Bridge documents the format specs for each tool and provides ready-to-use skill files so you can write once and port everywhere.

---

## Supported Tools

| Tool | File Format | Location | Trigger | Scope |
|------|------------|----------|---------|-------|
| **Hermes** | YAML frontmatter + Markdown | `~/.hermes/skills/<category>/<name>/SKILL.md` | Auto-loaded by name | Global |
| **Claude Code** | Pure Markdown (`.md`) | `~/.claude/commands/<name>.md` | `/name` slash command | Global or project |
| **Codex** | Pure Markdown (`.md`) | `~/.codex/skills/<name>.md` | Manual reference or `AGENTS.md` | Global |
| **Cursor** | `.mdc` with YAML frontmatter | `.cursor/rules/<name>.mdc` | Auto-loaded by glob | Project only |
| **OpenClaw** | Pure Markdown (`.md`) | `~/.openclaw/agents/main/SOUL.md` or standalone | SOUL.md injection or manual | Global |

---

## Quick Start

### One-click install (all tools)

```bash
./install.sh
```

### Install to specific tool(s)

```bash
./install.sh claude-code       # Single tool
./install.sh hermes cursor     # Multiple tools
```

### Manual install

Pick your tool and copy the skill file to the right location:

| Tool | Command |
|------|---------|
| **Hermes** | `cp hermes/skill.md ~/.hermes/skills/devops/ai-skill-bridge/SKILL.md` |
| **Claude Code** | `cp claude-code/skill.md ~/.claude/commands/ai-skill-bridge.md` |
| **Codex** | `mkdir -p ~/.codex/skills && cp codex/skill.md ~/.codex/skills/ai-skill-bridge.md` |
| **Cursor** | `mkdir -p .cursor/rules && cp cursor/skill.mdc .cursor/rules/ai-skill-bridge.mdc` |
| **OpenClaw** | `mkdir -p ~/.openclaw/skills && cp openclaw/skill.md ~/.openclaw/skills/ai-skill-bridge.md` |

> **Notes:**
> - **Claude Code** — `~/.claude/commands/` is global (all projects), `.claude/commands/` is project-only. Use `/ai-skill-bridge` to invoke.
> - **Codex** — No slash command. Tell Codex: `先读 ~/.codex/skills/ai-skill-bridge.md，然后按规范做`, or add to your project's `AGENTS.md`.
> - **Cursor** — Auto-loaded when editing any file in the project. No global equivalent.
> - **OpenClaw** — Reference from `~/.openclaw/agents/main/SOUL.md` (don't dump the full skill into SOUL.md).

---

## Pitfalls

> Read these before porting — they save time.

- **Do NOT copy YAML frontmatter verbatim across tools** — Claude Code and Codex render it as visible text, wasting context tokens.
- **Codex/OpenClaw have no slash commands** — Users must manually tell the tool to read the skill file, or embed the reference in `AGENTS.md` / `SOUL.md`.
- **Claude Code commands are global OR project** — `~/.claude/commands/` is global, `.claude/commands/` is project-only. Default to global for reusable skills.
- **Cursor rules are project-only** — No global equivalent. Copy `.mdc` into each project.
- **Keep one source of truth** — When updating, always update the canonical version first, then re-port. Don't maintain divergent copies.
- **OpenClaw SOUL.md is for persona** — Don't dump entire skill files into SOUL.md. Reference them instead.

---

## Format Comparison

<details>
<summary><strong>Frontmatter fields</strong></summary>

| Feature | Hermes | Claude Code | Codex | Cursor | OpenClaw |
|---------|--------|-------------|-------|--------|----------|
| YAML frontmatter | ✅ Required | ❌ Not used | ❌ Not used | ✅ Optional | ❌ Not used |
| `name` field | ✅ | — | — | — | — |
| `description` field | ✅ | — | — | ✅ | — |
| `trigger` field | ✅ | — | — | — | — |
| `tags` field | ✅ | — | — | — | — |
| `globs` field | — | — | — | ✅ | — |
| `alwaysApply` field | — | — | — | ✅ | — |

</details>

<details>
<summary><strong>Delivery mechanism</strong></summary>

| Feature | Hermes | Claude Code | Codex | Cursor | OpenClaw |
|---------|--------|-------------|-------|--------|----------|
| Slash command | ✅ (auto) | ✅ `/name` | ❌ | ❌ | ❌ |
| Auto-load | ✅ (by name) | ❌ | ❌ | ✅ (by glob) | ✅ (SOUL.md) |
| Project scope | ✅ | ✅ | ✅ (AGENTS.md) | ✅ | ❌ |
| Global scope | ✅ | ✅ | ✅ | ❌ | ✅ |
| Sub-files (refs, templates) | ✅ | ❌ | ❌ | ❌ | ❌ |

</details>

---

## How to Port a Skill

### Conversion Checklist

1. **Strip source-specific frontmatter** — Remove YAML blocks that are tool-specific metadata (e.g., Hermes `trigger`, `tags`; Cursor `globs`, `alwaysApply`). These don't transfer.
2. **Inline referenced files** — If the source skill references `references/`, `templates/`, `scripts/` subdirectories, inline the critical content into the main file. Most tools only support a single file.
3. **Keep core instructions intact** — All design rules, audit checklists, forbidden patterns, and workflow steps transfer as-is.
4. **Adapt delivery hints** — For tools without slash commands (Codex, OpenClaw), add a note at the top about how to invoke the skill.
5. **Verify file size** — Claude Code commands should stay under ~15KB to avoid context window bloat.
6. **Update registry** — Track which skills have been ported to which tools.

<details>
<summary><strong>Direction Matrix</strong> — What to strip/add per conversion</summary>

```
Source → Target: What to strip/add

Hermes → Claude Code:  Strip YAML frontmatter, inline sub-files
Hermes → Codex:        Strip YAML frontmatter, inline sub-files, add invocation hint
Hermes → Cursor:       Convert frontmatter to Cursor format (description/globs/alwaysApply)
Hermes → OpenClaw:     Strip YAML frontmatter, inline sub-files, add SOUL.md reference
Cursor → Claude Code:  Strip frontmatter, inline any referenced content
Cursor → Codex:        Strip frontmatter, add invocation hint
```

</details>

---

## Project Structure

<details>
<summary><strong>Show tree</strong></summary>

```
ai-skill-bridge/
├── README.md              ← English
├── README_CN.md           ← 中文版
├── install.sh             ← One-click installer
├── registry.md            ← Porting status tracker
├── hermes/
│   └── skill.md           (YAML frontmatter + markdown)
├── claude-code/
│   └── skill.md           (pure markdown)
├── codex/
│   └── skill.md           (pure markdown + invocation hint)
├── cursor/
│   └── skill.mdc          (Cursor .mdc format)
└── openclaw/
    └── skill.md           (pure markdown + SOUL.md reference)
```

</details>

---

## Contributing

1. The **Hermes version** (`hermes/skill.md`) is the canonical source of truth.
2. When updating, edit the Hermes version first, then port to other tools.
3. PRs welcome for:
   - New tool support (Windsurf, Aider, Continue, etc.)
   - Format spec corrections
   - New pitfalls or edge cases

---

## License

MIT
