     1|# AI Skill Bridge
     2|
     3|> **[English](README.md)** | 一套技能，所有工具通用。在 Hermes、Claude Code、Codex、Cursor、OpenClaw 之间无缝移植 AI 编程助手的 skill/rules。
     4|
     5|**痛点：** 你为某个 AI 编程工具精心写了一套 skill/rule，但它被锁死在那个工具的格式里。换工具？从头再写一遍。
     6|
     7|**解法：** AI Skill Bridge 整理了各工具的格式规范，并提供开箱即用的 skill 文件，让你写一次、到处用。
     8|
     9|---
    10|
    11|## 支持的工具
    12|
    13|| 工具 | 文件格式 | 存放路径 | 触发方式 | 作用域 |
    14||------|---------|----------|---------|-------|
    15|| **Hermes** | YAML frontmatter + Markdown | `~/.hermes/skills/<category>/<name>/SKILL.md` | 按名称自动加载 | 全局 |
    16|| **Claude Code** | 纯 Markdown (`.md`) | `~/.claude/commands/<name>.md` | `/name` 斜杠命令 | 全局或项目 |
    17|| **Codex** | 纯 Markdown (`.md`) | `~/.codex/skills/<name>.md` | 手动引用或写入 `AGENTS.md` | 全局 |
    18|| **Cursor** | `.mdc` + YAML frontmatter | `.cursor/rules/<name>.mdc` | 按 glob 模式自动加载 | 仅项目级 |
    19|| **OpenClaw** | 纯 Markdown (`.md`) | `~/.openclaw/agents/main/SOUL.md` 或独立文件 | SOUL.md 注入或手动引用 | 全局 |
    20|
    21|---
    22|
    23|## 快速开始
    24|
    25|选择你的工具，把 skill 文件复制到对应位置：
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
    36|# 全局（所有项目可用）
    37|cp claude-code/skill.md ~/.claude/commands/ai-skill-bridge.md
    38|
    39|# 仅当前项目
    40|cp claude-code/skill.md .claude/commands/ai-skill-bridge.md
    41|```
    42|
    43|然后在 Claude Code 中输入 `/ai-skill-bridge` 即可调用。
    44|
    45|### Codex
    46|
    47|```bash
    48|mkdir -p ~/.codex/skills
    49|cp codex/skill.md ~/.codex/skills/ai-skill-bridge.md
    50|```
    51|
    52|告诉 Codex：`先读 ~/.codex/skills/ai-skill-bridge.md，然后按规范做`
    53|
    54|或者写入项目的 `AGENTS.md`：
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
    66|编辑项目内任何文件时自动加载。
    67|
    68|### OpenClaw
    69|
    70|```bash
    71|mkdir -p ~/.openclaw/skills
    72|cp openclaw/skill.md ~/.openclaw/skills/ai-skill-bridge.md
    73|```
    74|
    75|在 `~/.openclaw/agents/main/SOUL.md` 中引用：
    76|```markdown
    77|For skill porting rules, read ~/.openclaw/skills/ai-skill-bridge.md
    78|```
    79|
    80|---
    81|
    82|## 格式对照表
    83|
    84|### Frontmatter 元数据
    85|
    86|| 特性 | Hermes | Claude Code | Codex | Cursor | OpenClaw |
    87||------|--------|-------------|-------|--------|----------|
    88|| YAML frontmatter | ✅ 必需 | ❌ 不使用 | ❌ 不使用 | ✅ 可选 | ❌ 不使用 |
    89|| `name` 字段 | ✅ | — | — | — | — |
    90|| `description` 字段 | ✅ | — | — | ✅ | — |
    91|| `trigger` 字段 | ✅ | — | — | — | — |
    92|| `tags` 字段 | ✅ | — | — | — | — |
    93|| `globs` 字段 | — | — | — | ✅ | — |
    94|| `alwaysApply` 字段 | — | — | — | ✅ | — |
    95|
    96|### 分发机制
    97|
    98|| 特性 | Hermes | Claude Code | Codex | Cursor | OpenClaw |
    99||------|--------|-------------|-------|--------|----------|
   100|| 斜杠命令 | ✅（自动） | ✅ `/name` | ❌ | ❌ | ❌ |
   101|| 自动加载 | ✅（按名称） | ❌ | ❌ | ✅（按 glob） | ✅（SOUL.md） |
   102|| 项目级作用域 | ✅ | ✅ | ✅（AGENTS.md） | ✅ | ❌ |
   103|| 全局作用域 | ✅ | ✅ | ✅ | ❌ | ✅ |
   104|| 子文件（引用/模板） | ✅ | ❌ | ❌ | ❌ | ❌ |
   105|
   106|---
   107|
   108|## 如何移植 Skill
   109|
   110|### 转换清单
   111|
   112|1. **剥离源工具的 frontmatter** — 去掉工具特有的 YAML 元数据（如 Hermes 的 `trigger`/`tags`，Cursor 的 `globs`/`alwaysApply`），这些不可迁移。
   113|
   114|2. **内联引用文件** — 如果源 skill 引用了 `references/`、`templates/`、`scripts/` 子目录，把关键内容合并到主文件中。大多数工具只支持单文件。
   115|
   116|3. **保留核心指令** — 所有设计规则、审查清单、禁用模式、工作流步骤原样迁移。
   117|
   118|4. **适配调用方式** — 对没有斜杠命令的工具（Codex、OpenClaw），在文件顶部加上调用说明。
   119|
   120|5. **检查文件大小** — Claude Code 命令建议控制在 15KB 以内，避免上下文窗口浪费。
   121|
   122|6. **更新移植记录** — 跟踪哪些 skill 已经移植到哪些工具。
   123|
   124|### 移植方向矩阵
   125|
   126|```
   127|源工具 → 目标工具：需要剥离/添加什么
   128|
   129|Hermes → Claude Code：  剥离 YAML frontmatter，内联子文件
   130|Hermes → Codex：        剥离 YAML frontmatter，内联子文件，加调用说明
   131|Hermes → Cursor：       转换 frontmatter 为 Cursor 格式（description/globs/alwaysApply）
   132|Hermes → OpenClaw：     剥离 YAML frontmatter，内联子文件，加 SOUL.md 引用
   133|Cursor → Claude Code：  剥离 frontmatter，内联引用内容
   134|Cursor → Codex：        剥离 frontmatter，加调用说明
   135|```
   136|
   137|---
   138|
   139|## 常见坑
   140|
   141|- **不要跨工具照搬 YAML frontmatter** — Claude Code 和 Codex 会把它当纯文本渲染，浪费上下文 token。
   142|- **Codex/OpenClaw 没有斜杠命令** — 用户必须手动告诉工具读取 skill 文件，或把引用写进 `AGENTS.md` / `SOUL.md`。
   143|- **Claude Code 命令分全局和项目级** — `~/.claude/commands/` 是全局的，`.claude/commands/` 是项目级的。通用 skill 默认放全局。
   144|- **Cursor 规则只有项目级** — 没有全局等价物，需要把 `.mdc` 复制到每个项目中。
   145|- **保持单一数据源** — 更新时先改规范版本（Hermes），再移植到其他工具，不要维护多份副本。
   146|- **OpenClaw 的 SOUL.md 用于定义人格** — 不要把整个 skill 文件塞进 SOUL.md，用引用的方式指向独立文件。
   147|
   148|---
   149|
   150|## 项目结构
   151|
   152|```
   153|ai-skill-bridge/
   154|├── README.md              ← English
   155|├── README_CN.md           ← 中文版
   156|├── hermes/
   157|│   └── skill.md           (YAML frontmatter + markdown)
   158|├── claude-code/
   159|│   └── skill.md           (纯 markdown)
   160|├── codex/
   161|│   └── skill.md           (纯 markdown + 调用说明)
   162|├── cursor/
   163|│   └── skill.mdc          (Cursor .mdc 格式)
   164|└── openclaw/
   165|    └── skill.md           (纯 markdown + SOUL.md 引用说明)
   166|```
   167|
   168|---
   169|
   170|## 贡献指南
   171|
   172|1. **Hermes 版本**（`hermes/skill.md`）是规范的数据源。
   173|2. 更新时先编辑 Hermes 版本，再移植到其他工具。
   174|3. 欢迎 PR：
   175|   - 新增工具支持（Windsurf、Aider、Continue 等）
   176|   - 格式规范修正
   177|   - 新的常见坑或边界情况
   178|
   179|---
   180|
   181|## 许可证
   182|
   183|MIT
   184|