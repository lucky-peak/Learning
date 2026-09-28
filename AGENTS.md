# LearnWithAI — 这是一个「学习」工作区，不是代码项目

这个仓库是用来**用 AI 学习**的。除非用户明确要求做别的事，**默认使用 `teach` skill** 来教任何东西（编程 / 英语 / 数学 / 通识）。

## 约定

- **默认技能**：`teach`。任何解释、讲解、答疑都按它的两条原则和 probe → plan → teach 流程走。
- **教学语言**：中文；英语内容保留英文原词。
- **格式**：数学一律用 LaTeX（`$...$`、`$$...$$`），因为内容会渲染进 Obsidian。
- **准确性**：任何事实/公式/用法不确定时，先用 `researcher` 子代理核实，别凭记忆硬讲。
- **学习者档案**：开课前读 `.pi/learner/profile.md`，结课时追加观察。只追加，不重写。
- **复习笔记**：结课时把当节知识点写成复习笔记，落到学习站点仓库的 `$SITE_DIR/content/learning/<slug>.md`（`SITE_DIR` 见 `.pi/learner/site.config`），`categories` 取 编程/英语/数学/通识 之一。
- **可视化**：需要图时用 `visualize` skill 派 `mermaid-maker` / `svg-maker` 子代理。
- **外部资料**：用到官方文档/书/课程/视频时，登记到 `resources/sources.md`，提炼要点到 `resources/extracts/`，抓不到的写进 `resources/wanted.md` 请用户提供；原文放 `resources/raw/`（不进 git）。
- **会话日志（可选）**：用 `/md-log <已有的 Obsidian 笔记路径>` 把会话镜像成 markdown。

## 目录

- `.pi/skills/teach/SKILL.md` — 教学哲学与流程（核心）
- `.pi/skills/visualize/SKILL.md` — 需要图时的可视化流程
- `.pi/agents/` — `mermaid-maker` / `svg-maker` 做图子代理
- `.pi/learner/profile.md` — 自适应学习者档案
- `.pi/learner/site.config` — 学习站点仓库路径与主题
- `.pi/extensions/` — `quiz`（评分出题）、`ask_user_question`、`md-log`
- `.pi/visual/render.sh` — 把 mermaid/svg 渲染成 PNG（供子代理自检）
- `.pi/scripts/preview-site.sh` — 本地预览学习站点
- `resources/` — 外部材料：`sources.md` 登记表、`wanted.md` 待你提供、`extracts/` 要点、`raw/` 原文（仅本地）
- `.pi/settings.json` — 模型与子代理配置
- `references/` — 收集的参考资料（只读，不修改）
