# Learning — 用 AI 学东西的 pi harness

一套把「教学哲学」工程化的 pi 配置：**一个只教你一个人的 AI 老师**。它负责全部后勤（探你的水平、排顺序、核事实、出题、画图、归类、沉淀复习笔记），你把认知资源全花在材料本身。

**一个工作区 = 一张持续生长的知识地图。** 老师既负责往里「长」（教 + 归类），也负责往外「引」（探索 + 启发）。

- 核心是两条教学原则 + `probe → plan → teach` 流程，编码在 `.pi/skills/teach/SKILL.md`。
- 学习者偏好由 `.pi/learner/profile.md` 逐步积累——系统在用的过程中**自适应**。
- 学过的所有东西整合进 `knowledge/` 的**分类树**：`知识点 → 主题（Flink）→ 领域（后端开发）`，领域之上不再约束。
- 有了全局地图，`explore` skill 能按**四象限**主动启发你接下来学什么。
- 每节课沉淀成**复习笔记**，一键发布到你的学习站点（Hugo）复习。

---

## 依赖

- [pi](https://github.com/earendil-works/pi)（本项目基于 0.86+ 开发）
- 一个支持**图像输入**的模型用于画图自检（默认 DeepSeek：`deepseek-flash` 有视觉，`deepseek-v4-pro` 没有）
- 把 SVG 渲染成 PNG：
  ```bash
  brew install librsvg
  ```
  （Mermaid 渲染走 `mermaid.ink`，不需要本地 Chrome。）

两个 pi 包已写进 `.pi/settings.json`，首次运行时 pi 会自动安装：

- `pi-web-access` — 联网搜索/抓取，给 `researcher` 核实事实用
- `pi-subagents` — 子代理（`researcher` / `oracle` / `evidence-auditor` + 自定义的 `mermaid-maker` / `svg-maker`）

---

## 快速开始

```bash
git clone https://github.com/lucky-peak/Learning.git ~/learning
cd ~/learning
# （可选）编辑 .pi/learner/site.config 设置 SITE_DIR 指向你的学习站点仓库
pi
```

进入交互界面后直接说：

- **「教我 Flink 的 Checkpointing」** → 走 `teach`
- **「接下来学什么？」** → 走 `explore`

首次会问是否信任本项目（因为装了项目级包），选信任。

就是这个工作区，一直用下去——不用为每个主题另建目录。

---

## 一节课是怎么进行的

`teach` 每次按同样**形状**跑三个阶段（大小随主题伸缩）：

1. **Probe** — 用带评分的 `quiz` 二分定位你的「理解边缘」，用 `ask_user_question` 问清你到底想学什么。全对不是结束，是题太简单，继续加难。
2. **Plan** — 先派 `researcher` 摸清领域与权威来源，再展示三样东西：方案、依赖图（Mermaid，无条件真理在根）、资源清单。**等你点头**。
3. **Teach** — 逐个节点走 `motivate → establish → connect → quiz-check`，一次一个推理步骤，随时可插问。

准确性不可妥协：任何事实/公式/用法不确定，先 `researcher` 核实再讲。

### 交互工具（仅 TUI 交互模式可用）

- `quiz` — 评分出题，即时反馈 ✓/✗ + 正确答案 + 解析
- `ask_user_question` — 没有对错的选择/偏好
- `/md-log <已存在的 Obsidian 笔记路径>` — 把会话实时镜像成 markdown（Obsidian 原生渲染 LaTeX/mermaid）

---

## 知识地图与归类

学过的知识点不再散落，而是长成一棵树，放在 `knowledge/`：

```
knowledge/
├── _index.md                 # Learning 落地页（发布）
├── _map.md                   # 全局地图：领域→主题→知识点 + 四象限状态（不发布）
├── programming/              # 领域（英文 slug）
│   ├── _index.md             # 领域标题（中文）+ 导读
│   └── python/               # 主题
│       ├── _index.md
│       └── list-vs-tuple.md  # 知识点（复习笔记）
└── math/
    └── arithmetic/
        └── negative-times-negative.md
```

**每次结课**，`teach` 做一次**归类/合并**：能并进已有主题就并；不能就在领域下新建主题；必要时把几个散点提升成一个新主题、把几个主题提到更大的领域。目录名一律英文 slug，显示名（中文）写在各自 `_index.md`。所有结构都记进 `knowledge/_map.md`。

---

## 探索：接下来学什么

`explore`（说「接下来学什么」或 `/skill:explore`）读 `knowledge/_map.md` + 学习者档案，按**四象限**产出建议：

| 象限 | 含义 | 系统怎么用它 |
|---|---|---|
| ✅ **知道自己知道** | 会，且知道 | 建议**进阶/深化** |
| 🎯 **知道自己不知道** | 不会，且知道 | 地图上记录的缺口 → **直接可学的下一节** |
| 💤 **不知道自己知道** | 会，但没意识到 | 凭直觉用对却没被确认过 → 提议**快速 probe 正式化** |
| 🕳 **不知道自己不知道** | 不知道，且不知道 | 从地图的**相邻盲区**主动提出（靠 `researcher` 找领域常识） |

前两格靠 probe 就够；后两格必须靠**全局地图 + 探索**才能浮出来——这正是把一切整合到一个工作区的最大收益。

---

## 资料（外部材料）

教学常要用官方文档、博客、书、课程、视频。**不囤积**——只做「登记 → 按需提取 → 引用」：

- **免费可抓的**（官方文档 / 博客 / 公开 PDF / YouTube）：用 `pi-web-access` 的 `fetch_content` 抓回来，只提炼本节用到的部分，写成 `resources/extracts/<slug>.md`。
- **抓不到的**（付费墙 / 极客时间 / 需登录 / 无公开源）：列进 `resources/wanted.md`，AI 会**具体地**告诉你需要哪份、为什么、怎么给（导出 PDF / 粘贴正文 / 截图 / 给本地路径）。
- **原文**（PDF/视频）：放 `resources/raw/`，**仅本地、不进 git**；复习笔记发布时只放链接。

```
resources/
├── sources.md      # 来源登记表
├── wanted.md       # 需要你提供的清单
├── extracts/       # 提炼后的要点笔记
└── raw/            # 抓取的原文（gitignore）
```

---

## 可视化

需要图时，`visualize` skill 会派：

- **`mermaid-maker`** — 结构性/关系性图（依赖图、流程、状态机）。返回**已验证的 mermaid 源码**，作为 ` ```mermaid ` 代码块嵌入（Obsidian / Hugo 都原生渲染）。
- **`svg-maker`** — 空间/几何图（数轴、向量、函数图像）。把 PNG/SVG 存进 `viz/` 并返回文件名。

两者都会**渲染出来、亲眼看一遍、迭代到正确**才交付（用 `.pi/visual/render.sh`）。因为要读图，maker 用的是支持图像输入的模型。

---

## 发布到学习站点

`.pi/scripts/publish-learning.sh` 把 `knowledge/` 同步到站点：

```
knowledge/  ->  $SITE_DIR/content/learning/     # 排除 _map.md
```

- 站点侧（Hugo + FixIt）需要一个 `Learning` tab 和 `layouts/learning/section.html`（按 领域 → 主题 → 知识点 三层渲染）。
- 发布**不自动 push**；脚本会提示你自己 commit/push 触发部署。

本地预览站点：

```bash
.pi/scripts/preview-site.sh
```

> 该站点主题锁定 Hugo 0.123.8（新版 Hugo 移除了主题用到的 `getJSON`）。`preview-site.sh` 会自动准备对应版本。

---

## 配置

| 文件 | 作用 |
|---|---|
| `.pi/settings.json` | 模型与子代理默认值。主教学 `deepseek-v4-pro`（thinking high），子代理默认 `deepseek-flash`，`researcher`/`oracle` 用 `deepseek-v4-pro` |
| `.pi/learner/profile.md` | 自适应学习者档案。**开课前读，结课后追加**（只追加不重写） |
| `.pi/learner/site.config` | 学习站点仓库路径 `SITE_DIR` |
| `.pi/learner/` + `knowledge/_map.md` | 学习状态与知识地图 |

改模型：编辑 `.pi/settings.json` 的 `defaultModel` / `subagents.defaultModel`。不绑定 DeepSeek，换成支持对应能力的模型即可。

---

## 目录结构

```
.
├── AGENTS.md                     # 项目约定
├── README.md
├── knowledge/                    # 知识树（领域 → 主题 → 知识点）；_map.md 是全局地图
├── resources/                    # 外部材料（sources / wanted / extracts / raw）
├── viz/                          # 生成的图（产物 gitignore）
└── .pi/
    ├── settings.json             # 模型 + 子代理 + packages
    ├── skills/
    │   ├── teach/SKILL.md        # 教学哲学与流程（核心）
    │   ├── visualize/SKILL.md    # 可视化流程
    │   └── explore/SKILL.md      # 四象限探索/启发
    ├── agents/
    │   ├── mermaid-maker.md
    │   └── svg-maker.md
    ├── extensions/
    │   ├── quiz.ts
    │   ├── ask-user-question.ts
    │   └── md-log.ts
    ├── learner/
    │   ├── profile.md            # 自适应学习者档案
    │   └── site.config           # 站点路径
    ├── visual/render.sh          # mermaid/svg → PNG
    └── scripts/
        ├── publish-learning.sh   # knowledge/ → 站点
        └── preview-site.sh       # 本地预览站点
```

---

## 参考资料

本项目基于 / 参考了以下公开材料（未随仓库分发）：

- [amosblomqvist/learn](https://github.com/amosblomqvist/learn) — 原始的教学系统（`teach` skill、三阶段流程、quiz/md-log 扩展、做图子代理）
- [mattpocock/skills](https://github.com/mattpocock/skills) — 通用技能库
- [yfrobotics/self-driving-handbook-cn](https://github.com/yfrobotics/self-driving-handbook-cn) — 分类分章的 handbook 组织方式参考
- 视频 *How I Use AI to Learn Things* — 整套系统的教学哲学来源

## 致谢

教学哲学与流程改编自 amosblomqvist/learn；本仓库做了这些适配：中文多领域、`pi-subagents` 子代理、`mermaid.ink`/`rsvg-convert` 做图自检、自适应学习者档案、知识地图与四象限探索、以及发布到 Hugo 站点的复习笔记。
