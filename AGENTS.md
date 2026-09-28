# Learning — 用 AI 学习的工作区，不是代码项目

这是一个**单工作区**：clone 一次，就在这里学所有东西。除非用户明确要求做别的事，默认用 `teach` / `explore` skill。

## 约定

- **默认技能**
  - `teach`——「教我 X」。任何解释、讲解、答疑都按它的两条原则和 probe → plan → teach 流程走。
  - `explore`——「接下来学什么」。基于知识地图按四象限主动启发。
- **教学语言**：中文；英语内容保留英文原词。
- **格式**：数学一律用 LaTeX（`$...$`、`$$...$$`），内容会渲染进 Obsidian 与学习站点。
- **准确性**：任何事实/公式/用法不确定时，先用 `researcher` 子代理核实，别凭记忆硬讲。
- **开课前**：读 `.pi/learner/profile.md`（学习者偏好）和 `knowledge/_map.md`（知识地图）。
- **结课时**：写回档案 + 把知识点**归类进知识树** `knowledge/`（领域 → 主题 → 知识点），并更新 `_map.md`。
- **可视化**：需要图时用 `visualize` skill 派 `mermaid-maker` / `svg-maker` 子代理。
- **外部资料**：登记到 `resources/sources.md`，要点到 `resources/extracts/`，抓不到的写进 `resources/wanted.md` 请用户提供；原文放 `resources/raw/`（不进 git）。
- **发布**：`.pi/scripts/publish-learning.sh` 把 `knowledge/` 同步到学习站点；不自动 push。
- **会话日志（可选）**：`/md-log <已有的 Obsidian 笔记路径>`。

## 目录

- `knowledge/` — **知识树**（领域 → 主题 → 知识点）；`_map.md` 是全局地图（不发布）
- `resources/` — 外部材料（`sources.md` / `wanted.md` / `extracts/` / `raw/`）
- `viz/` — 生成的图
- `.pi/skills/` — `teach` / `visualize` / `explore`
- `.pi/agents/` — `mermaid-maker` / `svg-maker`
- `.pi/extensions/` — `quiz` / `ask_user_question` / `md-log`
- `.pi/learner/` — `profile.md`（学习者档案）/ `site.config`（站点路径）
- `.pi/scripts/` — `publish-learning.sh` / `preview-site.sh`
- `.pi/visual/render.sh` — mermaid/svg → PNG（供 maker 自检）
- `.pi/settings.json` — 模型与子代理配置
- `references/` — 收集的参考资料（只读，不修改）
