     1|# Cross-Tool Skill Distribution
     2|
     3|> **Usage:** Reference this file from SOUL.md or tell OpenClaw to read it before porting skills.
     4|
     5|Port AI coding assistant skills/rules across tools. Each tool has its own format, directory, and delivery mechanism.
     6|
     7|## Tool Format Specs
     8|
     9|### Hermes — `~/.hermes/skills/`
    10|
    11|- **Location:** `~/.hermes/skills/<category>/<name>/SKILL.md` (global)
    12|- **Trigger:** Auto-loaded by skill name, or explicit `skill_view(name)`
    13|- **Format:** YAML frontmatter (`name`, `description`, `trigger`, `tags`, `category`) + markdown body
    14|- **Naming:** Directory name = skill name, kebab-case
    15|
    16|### Claude Code — `~/.claude/commands/`
    17|
    18|- **Location:** `~/.claude/commands/<name>.md` (global), `.claude/commands/<name>.md` (project)
    19|- **Trigger:** Slash command `/name` in Claude Code CLI
    20|- **Format:** Pure markdown, NO YAML frontmatter
    21|- **Naming:** Filename = command name, kebab-case
    22|
    23|### Codex — `~/.codex/skills/`
    24|
    25|- **Location:** `~/.codex/skills/<name>.md` (reference), `AGENTS.md` (project-level)
    26|- **Trigger:** No native command system. Manually referenced or included in `AGENTS.md`
    27|- **Format:** Pure markdown, NO YAML frontmatter
    28|
    29|### Cursor — `.cursor/rules/`
    30|
    31|- **Location:** `.cursor/rules/<name>.mdc` (project-level) or `.cursorrules` (legacy)
    32|- **Trigger:** Auto-loaded based on glob patterns or always-on
    33|- **Format:** `.mdc` with optional YAML frontmatter (`description`, `globs`, `alwaysApply`)
    34|- **Note:** Project-scoped only, no global equivalent
    35|
    36|### OpenClaw — `~/.openclaw/agents/`
    37|
    38|- **Location:** `~/.openclaw/agents/main/SOUL.md` (always loaded), standalone `.md` for reference
    39|- **Trigger:** SOUL.md auto-injected; other files explicitly referenced
    40|- **Format:** Pure markdown, NO YAML frontmatter
    41|- **Usage:** Add to SOUL.md: `For skill porting, read ~/.openclaw/skills/skill.md`
    42|
    43|## Conversion Checklist
    44|
    45|1. **Strip source-specific frontmatter** — Remove tool-specific YAML metadata.
    46|2. **Inline referenced files** — Merge `references/`, `templates/`, `scripts/` content into main file.
    47|3. **Keep core instructions intact** — Rules, checklists, patterns, workflows transfer as-is.
    48|4. **Adapt delivery hints** — Add invocation notes for tools without slash commands.
    49|5. **Verify file size** — Keep under ~15KB for Claude Code commands.
    50|6. **Update registry** — Track ports in a central registry.
    51|
    52|## Pitfalls
    53|
    54|- Do NOT copy YAML frontmatter verbatim — wastes context tokens.
    55|- OpenClaw SOUL.md is for persona — don't dump entire skills into it, reference them.
    56|- Keep one source of truth — update canonical version first, then re-port.
    57|- OpenClaw has no slash command system — skills must be explicitly referenced in conversation or SOUL.md.
    58|