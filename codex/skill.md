     1|<!-- Usage: Tell Codex "先读 ~/.codex/skills/skill.md，然后按规范做" -->
     2|<!-- Or add to project AGENTS.md: "For skill porting, read ~/.codex/skills/skill.md" -->
     3|
     4|# Cross-Tool Skill Distribution
     5|
     6|Port AI coding assistant skills/rules across tools. Each tool has its own format, directory, and delivery mechanism.
     7|
     8|## Tool Format Specs
     9|
    10|### Hermes — `~/.hermes/skills/`
    11|
    12|- **Location:** `~/.hermes/skills/<category>/<name>/SKILL.md` (global)
    13|- **Trigger:** Auto-loaded by skill name, or explicit `skill_view(name)`
    14|- **Format:** YAML frontmatter (`name`, `description`, `trigger`, `tags`, `category`) + markdown body
    15|- **Naming:** Directory name = skill name, kebab-case
    16|
    17|### Claude Code — `~/.claude/commands/`
    18|
    19|- **Location:** `~/.claude/commands/<name>.md` (global), `.claude/commands/<name>.md` (project)
    20|- **Trigger:** Slash command `/name` in Claude Code CLI
    21|- **Format:** Pure markdown, NO YAML frontmatter
    22|- **Naming:** Filename = command name, kebab-case
    23|
    24|### Codex — `~/.codex/skills/`
    25|
    26|- **Location:** `~/.codex/skills/<name>.md` (reference), `AGENTS.md` (project-level)
    27|- **Trigger:** No native command system. Manually referenced or included in `AGENTS.md`
    28|- **Format:** Pure markdown, NO YAML frontmatter
    29|
    30|### Cursor — `.cursor/rules/`
    31|
    32|- **Location:** `.cursor/rules/<name>.mdc` (project-level) or `.cursorrules` (legacy)
    33|- **Trigger:** Auto-loaded based on glob patterns or always-on
    34|- **Format:** `.mdc` with optional YAML frontmatter (`description`, `globs`, `alwaysApply`)
    35|- **Note:** Project-scoped only, no global equivalent
    36|
    37|### OpenClaw — `~/.openclaw/agents/`
    38|
    39|- **Location:** `~/.openclaw/agents/main/SOUL.md` (always loaded), standalone `.md` for reference
    40|- **Trigger:** SOUL.md auto-injected; other files explicitly referenced
    41|- **Format:** Pure markdown, NO YAML frontmatter
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
    55|- Codex has no slash commands — reference files manually or via AGENTS.md.
    56|- Keep one source of truth — update canonical version first, then re-port.
    57|