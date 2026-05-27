     1|---
     2|name: ai-skill-bridge
     3|description: Port AI coding assistant skills/rules across tools — Hermes, Claude Code, Codex, Cursor, OpenClaw. Format specs, directory conventions, and conversion checklist.
     4|category: devops
     5|tags: [cross-tool, skill-porting, claude-code, codex, cursor, openclaw]
     6|trigger: port skill, sync skill, 分发skill, 多工具同步, install to claude code, install to codex
     7|---
     8|
     9|# Cross-Tool Skill Distribution
    10|
    11|Port AI coding assistant skills/rules across tools. Each tool has its own format, directory, and delivery mechanism.
    12|
    13|---
    14|
    15|## Tool Format Specs
    16|
    17|### Hermes — `~/.hermes/skills/`
    18|
    19|- **Location:** `~/.hermes/skills/<category>/<name>/SKILL.md` (global)
    20|- **Trigger:** Auto-loaded by skill name in conversation, or explicit `skill_view(name)`
    21|- **Format:** YAML frontmatter (`name`, `description`, `trigger`, `tags`, `category`) + markdown body
    22|- **Content:** SKILL.md is the main file; optional `references/`, `templates/`, `scripts/` subdirectories
    23|- **Naming:** Directory name = skill name. Use kebab-case (e.g., `ai-skill-bridge`)
    24|
    25|### Claude Code — `~/.claude/commands/`
    26|
    27|- **Location:** `~/.claude/commands/<name>.md` (global), `.claude/commands/<name>.md` (project)
    28|- **Trigger:** Slash command `/name` in Claude Code CLI
    29|- **Format:** Pure markdown, NO YAML frontmatter
    30|- **Content:** The entire `.md` file is injected as system instructions when the command is invoked
    31|- **Naming:** Filename = command name. Use kebab-case (e.g., `ai-skill-bridge.md` → `/ai-skill-bridge`)
    32|
    33|### Codex — `~/.codex/skills/`
    34|
    35|- **Location:** `~/.codex/skills/<name>.md` (reference), `AGENTS.md` (project-level injection)
    36|- **Trigger:** No native command system. Must be manually referenced in conversation or included in `AGENTS.md`
    37|- **Format:** Pure markdown, NO YAML frontmatter
    38|- **Content:** Standalone instruction file that can be read by Codex when referenced
    39|- **Usage patterns:**
    40|  - Tell Codex: "先读 ~/.codex/skills/ai-skill-bridge.md，然后按规范做"
    41|  - Or add to project `AGENTS.md`: `For skill porting, read ~/.codex/skills/ai-skill-bridge.md`
    42|
    43|### Cursor — `.cursor/rules/`
    44|
    45|- **Location:** `.cursor/rules/<name>.mdc` (project-level, newer) or `.cursorrules` (project root, legacy)
    46|- **Trigger:** Auto-loaded based on file glob patterns or always-on
    47|- **Format:** `.mdc` files with optional YAML frontmatter (`description`, `globs`, `alwaysApply`)
    48|- **Note:** Cursor rules are project-scoped only, no global equivalent
    49|
    50|### OpenClaw — `~/.openclaw/agents/`
    51|
    52|- **Location:** `~/.openclaw/agents/main/SOUL.md` (agent persona, always loaded), standalone `.md` files for reference
    53|- **Trigger:** SOUL.md is auto-injected into every session; other files must be explicitly referenced
    54|- **Format:** Pure markdown, NO YAML frontmatter
    55|- **Content:** SOUL.md defines identity and boundaries; supplementary skill files can be referenced from SOUL.md or mentioned in conversation
    56|- **Usage patterns:**
    57|  - Add to SOUL.md: `For skill porting rules, read ~/.openclaw/skills/ai-skill-bridge.md`
    58|  - Or tell OpenClaw: "先读 ai-skill-bridge.md，然后按规范做"
    59|
    60|---
    61|
    62|## Conversion Checklist
    63|
    64|When porting a skill across tools:
    65|
    66|1. **Strip source-specific frontmatter** — Remove YAML blocks that are tool-specific metadata (e.g., Hermes `trigger`, `tags`; Cursor `globs`, `alwaysApply`). These don't transfer.
    67|2. **Inline referenced files** — If the source skill references `references/`, `templates/`, `scripts/` subdirectories, inline the critical content into the main file. Most tools only support a single file.
    68|3. **Keep core instructions intact** — All design rules, audit checklists, forbidden patterns, and workflow steps transfer as-is.
    69|4. **Adapt delivery hints** — For tools without slash commands (Codex, OpenClaw), add a note at the top about how to invoke the skill.
    70|5. **Verify file size** — Claude Code commands should stay under ~15KB to avoid context window bloat.
    71|6. **Update registry** — Track which skills have been ported to which tools in a central registry file.
    72|
    73|---
    74|
    75|## Pitfalls
    76|
    77|- **Do NOT copy YAML frontmatter verbatim across tools** — Claude Code and Codex will render it as visible text, wasting context tokens.
    78|- **Codex/OpenClaw have no slash commands** — Users must manually tell the tool to read the skill file, or embed the reference in AGENTS.md / SOUL.md.
    79|- **Claude Code commands are global OR project** — `~/.claude/commands/` is global (all projects), `.claude/commands/` is project-only. Default to global for reusable skills.
    80|- **Cursor rules are project-only** — No global equivalent. Skills must be copied into each project's `.cursor/rules/` directory.
    81|- **Keep one source of truth** — When updating, always update the canonical version first, then re-port. Don't maintain divergent copies.
    82|- **OpenClaw SOUL.md is for persona** — Don't dump entire skill files into SOUL.md. Reference them instead.
    83|