     1|# AI Skill Bridge
     2|
     3|> **[中文版](README_CN.md)** | One skill, every tool. Port your AI coding assistant skills/rules across Hermes, Claude Code, Codex, Cursor, and OpenClaw.
     4|
     5|**The problem:** You write a great skill/rule for one AI coding tool, but it's locked into that tool's format. Switch tools? Rewrite from scratch.
     6|
     7|**The solution:** AI Skill Bridge documents the format specs for each tool and provides ready-to-use skill files so you can write once and port everywhere.
     8|
     9|---
    10|
    11|## Supported Tools
    12|
    13|| Tool | File Format | Location | Trigger | Scope |
    14||------|------------|----------|---------|-------|
    15|| **Hermes** | YAML frontmatter + Markdown | `~/.hermes/skills/<category>/<name>/SKILL.md` | Auto-loaded by name | Global |
    16|| **Claude Code** | Pure Markdown (`.md`) | `~/.claude/commands/<name>.md` | `/name` slash command | Global or project |
    17|| **Codex** | Pure Markdown (`.md`) | `~/.codex/skills/<name>.md` | Manual reference or `AGENTS.md` | Global |
    18|| **Cursor** | `.mdc` with YAML frontmatter | `.cursor/rules/<name>.mdc` | Auto-loaded by glob | Project only |
    19|| **OpenClaw** | Pure Markdown (`.md`) | `~/.openclaw/agents/main/SOUL.md` or standalone | SOUL.md injection or manual | Global |
    20|
    21|---
    22|
    23|## Quick Start
    24|
    25|Pick your tool and copy the skill file to the right location:
    26|
    27|### Hermes
    28|
    29|```bash
    30|cp hermes/skill.md ~/.hermes/skills/devops/ai-skill-bridge/SKILL.md
    31|```
    32|
    33|### Claude Code
    34|
    35|```bash
    36|# Global (all projects)
    37|cp claude-code/skill.md ~/.claude/commands/ai-skill-bridge.md
    38|
    39|# Project-only
    40|cp claude-code/skill.md .claude/commands/ai-skill-bridge.md
    41|```
    42|
    43|Then use `/ai-skill-bridge` in Claude Code.
    44|
    45|### Codex
    46|
    47|```bash
    48|mkdir -p ~/.codex/skills
    49|cp codex/skill.md ~/.codex/skills/ai-skill-bridge.md
    50|```
    51|
    52|Then tell Codex: `先读 ~/.codex/skills/ai-skill-bridge.md，然后按规范做`
    53|
    54|Or add to your project's `AGENTS.md`:
    55|```
    56|For skill porting rules, read ~/.codex/skills/ai-skill-bridge.md
    57|```
    58|
    59|### Cursor
    60|
    61|```bash
    62|mkdir -p .cursor/rules
    63|cp cursor/skill.mdc .cursor/rules/ai-skill-bridge.mdc
    64|```
    65|
    66|Auto-loaded when editing any file in the project.
    67|
    68|### OpenClaw
    69|
    70|```bash
    71|mkdir -p ~/.openclaw/skills
    72|cp openclaw/skill.md ~/.openclaw/skills/ai-skill-bridge.md
    73|```
    74|
    75|Reference from `~/.openclaw/agents/main/SOUL.md`:
    76|```markdown
    77|For skill porting rules, read ~/.openclaw/skills/ai-skill-bridge.md
    78|```
    79|
    80|---
    81|
    82|## Format Comparison
    83|
    84|### Frontmatter
    85|
    86|| Feature | Hermes | Claude Code | Codex | Cursor | OpenClaw |
    87||---------|--------|-------------|-------|--------|----------|
    88|| YAML frontmatter | ✅ Required | ❌ Not used | ❌ Not used | ✅ Optional | ❌ Not used |
    89|| `name` field | ✅ | — | — | — | — |
    90|| `description` field | ✅ | — | — | ✅ | — |
    91|| `trigger` field | ✅ | — | — | — | — |
    92|| `tags` field | ✅ | — | — | — | — |
    93|| `globs` field | — | — | — | ✅ | — |
    94|| `alwaysApply` field | — | — | — | ✅ | — |
    95|
    96|### Delivery
    97|
    98|| Feature | Hermes | Claude Code | Codex | Cursor | OpenClaw |
    99||---------|--------|-------------|-------|--------|----------|
   100|| Slash command | ✅ (auto) | ✅ `/name` | ❌ | ❌ | ❌ |
   101|| Auto-load | ✅ (by name) | ❌ | ❌ | ✅ (by glob) | ✅ (SOUL.md) |
   102|| Project scope | ✅ | ✅ | ✅ (AGENTS.md) | ✅ | ❌ |
   103|| Global scope | ✅ | ✅ | ✅ | ❌ | ✅ |
   104|| Sub-files (refs, templates) | ✅ | ❌ | ❌ | ❌ | ❌ |
   105|
   106|---
   107|
   108|## How to Port a Skill
   109|
   110|### Conversion Checklist
   111|
   112|1. **Strip source-specific frontmatter** — Remove YAML blocks that are tool-specific metadata (e.g., Hermes `trigger`, `tags`; Cursor `globs`, `alwaysApply`). These don't transfer.
   113|
   114|2. **Inline referenced files** — If the source skill references `references/`, `templates/`, `scripts/` subdirectories, inline the critical content into the main file. Most tools only support a single file.
   115|
   116|3. **Keep core instructions intact** — All design rules, audit checklists, forbidden patterns, and workflow steps transfer as-is.
   117|
   118|4. **Adapt delivery hints** — For tools without slash commands (Codex, OpenClaw), add a note at the top about how to invoke the skill.
   119|
   120|5. **Verify file size** — Claude Code commands should stay under ~15KB to avoid context window bloat.
   121|
   122|6. **Update registry** — Track which skills have been ported to which tools.
   123|
   124|### Direction Matrix
   125|
   126|```
   127|Source → Target: What to strip/add
   128|
   129|Hermes → Claude Code:  Strip YAML frontmatter, inline sub-files
   130|Hermes → Codex:        Strip YAML frontmatter, inline sub-files, add invocation hint
   131|Hermes → Cursor:       Convert frontmatter to Cursor format (description/globs/alwaysApply)
   132|Hermes → OpenClaw:     Strip YAML frontmatter, inline sub-files, add SOUL.md reference
   133|Cursor → Claude Code:  Strip frontmatter, inline any referenced content
   134|Cursor → Codex:        Strip frontmatter, add invocation hint
   135|```
   136|
   137|---
   138|
   139|## Pitfalls
   140|
   141|- **Do NOT copy YAML frontmatter verbatim across tools** — Claude Code and Codex render it as visible text, wasting context tokens.
   142|- **Codex/OpenClaw have no slash commands** — Users must manually tell the tool to read the skill file, or embed the reference in `AGENTS.md` / `SOUL.md`.
   143|- **Claude Code commands are global OR project** — `~/.claude/commands/` is global, `.claude/commands/` is project-only. Default to global for reusable skills.
   144|- **Cursor rules are project-only** — No global equivalent. Copy `.mdc` into each project.
   145|- **Keep one source of truth** — When updating, always update the canonical version first, then re-port. Don't maintain divergent copies.
   146|- **OpenClaw SOUL.md is for persona** — Don't dump entire skill files into SOUL.md. Reference them instead.
   147|
   148|---
   149|
   150|## Project Structure
   151|
   152|```
   153|ai-skill-bridge/
   154|├── README.md              ← English
   155|├── README_CN.md           ← 中文版
   156|├── hermes/
   157|│   └── skill.md           (YAML frontmatter + markdown)
   158|├── claude-code/
   159|│   └── skill.md           (pure markdown)
   160|├── codex/
   161|│   └── skill.md           (pure markdown + invocation hint)
   162|├── cursor/
   163|│   └── skill.mdc          (Cursor .mdc format)
   164|└── openclaw/
   165|    └── skill.md           (pure markdown + SOUL.md reference)
   166|```
   167|
   168|---
   169|
   170|## Contributing
   171|
   172|1. The **Hermes version** (`hermes/skill.md`) is the canonical source of truth.
   173|2. When updating, edit the Hermes version first, then port to other tools.
   174|3. PRs welcome for:
   175|   - New tool support (Windsurf, Aider, Continue, etc.)
   176|   - Format spec corrections
   177|   - New pitfalls or edge cases
   178|
   179|---
   180|
   181|## License
   182|
   183|MIT
   184|