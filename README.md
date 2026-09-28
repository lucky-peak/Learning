# Learning — 用 AI 学东西的 pi harness

一套把「教学哲学」工程化的 pi 配置：**一个只教你一个人的 AI 老师**。它负责全部后勤（探你的水平、排顺序、核事实、出题、画图、沉淀复习笔记），你把认知资源全花在材料本身。

- 核心是两条教学原则 + `probe → plan → teach` 流程，编码在 `.pi/skills/teach/SKILL.md`。
- 学习者偏好由 `.pi/learner/profile.md` 逐步积累——系统在用的过程中**自适应**，而不是一开始就要你说清"我的学习哲学"。
- 覆盖：**编程 / 英语 / 数学 / 通识**，教学语言中文（英语内容保留原词），数学用 LaTeX。
- 每节课结束会把知识点沉淀成**复习笔记**，发布到你的学习站点（Hugo），按主题分组，方便回看。

---

## 依赖

- [pi](https://github.com/earendil-works/pi)（本项目基于 0.86+ 开发）
- 一个支持**图像输入**的模型用于画图自检（本项目默认 DeepSeek：`deepseek-flash` 有视觉，`deepseek-v4-pro` 没有）
- 用于把 SVG 渲染成 PNG：
  ```bash
  brew install librsvg
  ```
  （Mermaid 渲染走 `mermaid.ink`，不需要本地 Chrome。）

两个 pi 包已写进 `.pi/settings.json`，首次运行时 pi 会自动安装：

- `pi-web-access` — 联网搜索/抓取，给 `researcher` 核实事实用
- `pi-subagents` — 子代理（`researcher` / `oracle` / `evidence-auditor` + 本项目自定义的 `mermaid-maker` / `svg-maker`）

---

## 快速开始

### 方式 A：直接把它当成一个学习工作区

```bash
git clone https://github.com/lucky-peak/Learning.git ~/learn/my-topic
cd ~/learn/my-topic
# 编辑 .pi/learner/site.config 设好 SITE_DIR（学习站点仓库路径），或先留空
pi
```

进入交互界面后，直接说「教我 X」即可。首次会问是否信任本项目（因为装了项目级包），选信任。

### 方式 B：一个 harness 复制出多个工作区

```bash
git clone https://github.com/lucky-peak/Learning.git ~/learn/harness
bash ~/learn/harness/scripts/new-workspace.sh ~/learn/kubernetes
bash ~/learn/harness/scripts/new-workspace.sh ~/learn/english-writing
```

每个新目录都是一个独立的学习工作区，可以分别 `cd` 进去 `pi`。新工作区会带上当前的 `profile.md`（学习者是同一个人），你可以按需重置或软链共享。

---

## 一节课是怎么进行的

`teach` skill 每次都会按同样**形状**跑三个阶段（大小随主题伸缩）：

1. **Probe** — 用带评分的 `quiz` 二分定位你的「理解边缘」，用 `ask_user_question` 问清你到底想学什么。全对不是结束，是题太简单，继续加难。
2. **Plan** — 先派 `researcher` 摸清领域，再画一张依赖图（Mermaid，无条件真理在根），讲给你听后**等你点头**。
3. **Teach** — 逐个节点走 `motivate → establish → connect → quiz-check`，一次一个推理步骤，随时可插问。

准确性不可妥协：任何事实/公式/用法不确定，先 `researcher` 核实再讲。

### 交互工具（仅在 TUI 交互模式可用）

- `quiz` — 评分出题，即时反馈 ✓/✗ + 正确答案 + 解析
- `ask_user_question` — 没有对错的选择/偏好
- `/md-log <已存在的 Obsidian 笔记路径>` — 把会话实时镜像成 markdown（Obsidian 原生渲染 LaTeX/mermaid）

---

## 配置

| 文件 | 作用 |
|---|---|
| `.pi/settings.json` | 模型与子代理默认值。主教学 `deepseek-v4-pro`（thinking high），子代理默认 `deepseek-flash`，`researcher`/`oracle` 用 `deepseek-v4-pro` |
| `.pi/learner/profile.md` | 自适应学习者档案。**开课前读，结课后追加**（只追加不重写） |
| `.pi/learner/site.config` | 学习站点仓库路径 `SITE_DIR` 与主题列表 `TOPICS` |
| `AGENTS.md` | 项目级约定（默认走 `teach`、LaTeX、先核实再讲等） |

改模型：编辑 `.pi/settings.json` 的 `defaultModel` / `subagents.defaultModel`。只要换成支持相应能力的模型即可，不绑定 DeepSeek。

---

## 可视化

需要图时，`visualize` skill 会派：

- **`mermaid-maker`** — 结构性/关系性图（依赖图、流程、状态机）。返回**已验证的 mermaid 源码**，直接作为 ` ```mermaid ` 代码块嵌入（Obsidian / Hugo 都原生渲染）。
- **`svg-maker`** — 空间/几何图（数轴、向量、函数图像）。把 PNG/SVG 存进 `viz/` 并返回文件名。

两者都会**渲染出来、亲眼看一遍、迭代到正确**才交付（用 `.pi/visual/render.sh`）。因为要读图，maker 用的是支持图像输入的模型。

> SVG 的 Obsidian 嵌入要求 `viz/` 在 vault 内；mermaid 用代码块则不受影响。

---

## 资料（外部材料）

教学常要用官方文档、博客、书、课程、视频。**不囤积**——只做「登记 → 按需提取 → 引用」：

- **免费可抓的**（官方文档 / 博客 / 公开 PDF / YouTube）：用 `pi-web-access` 的 `fetch_content` 抓回来，只提炼本节用到的部分，写成 `resources/extracts/<slug>.md`（你自己的话 + 出处 + 日期）。
- **抓不到的**（付费墙 / 极客时间 / 需登录 / 无公开源）：列进 `resources/wanted.md`，AI 会**具体地**告诉你需要哪份、为什么、怎么给（导出 PDF / 粘贴正文 / 截图 / 给本地路径）。
- **原文**（PDF/视频）：放 `resources/raw/`，**仅本地、不进 git**；复习笔记发布时只放链接。

```
resources/
├── sources.md      # 来源登记表
├── wanted.md       # 需要你提供的清单
├── extracts/       # 提炼后的要点笔记
└── raw/            # 抓取的原文（gitignore）
```

## 发布到学习站点

结课时 `teach` 会把知识点写成复习笔记，落到：

```
$SITE_DIR/content/learning/<slug>.md     # categories 取 编程/英语/数学/通识 之一
$SITE_DIR/static/learning/<file>          # 图片（如有）
```

站点侧（Hugo + FixIt）需要一个 `Learning` tab 和按主题分组的列表模板，见目标仓库的 `layouts/learning/section.html` 与 `content/learning/`。写完**不会自动 push**，由你自己 commit/push 触发部署。

本地预览站点：

```bash
.pi/scripts/preview-site.sh
```

> 注意：该站点主题锁定 Hugo 0.123.8（新版 Hugo 移除了主题用到的 `getJSON`）。`preview-site.sh` 会自动准备好对应版本。

---

## 目录结构

```
.
├── AGENTS.md                     # 项目约定
├── README.md
├── scripts/
│   └── new-workspace.sh          # 从本 harness 复制出一个新学习工作区
├── resources/                    # 外部材料：来源登记 / 要点 / 待你提供（原文 gitignore）
├── viz/                          # 生成的图（产物 gitignore）
└── .pi/
    ├── settings.json             # 模型 + 子代理 + packages
    ├── skills/
    │   ├── teach/SKILL.md        # 教学哲学与流程（核心）
    │   └── visualize/SKILL.md    # 可视化流程
    ├── agents/
    │   ├── mermaid-maker.md      # 结构性图 maker
    │   └── svg-maker.md          # 几何图 maker
    ├── extensions/
    │   ├── quiz.ts               # 评分出题
    │   ├── ask-user-question.ts  # 无对错选择
    │   └── md-log.ts             # 会话 → markdown
    ├── learner/
    │   ├── profile.md            # 自适应学习者档案
    │   └── site.config           # 站点路径与主题
    ├── visual/render.sh          # mermaid/svg → PNG（供 maker 自检）
    └── scripts/preview-site.sh   # 本地预览学习站点
```

---

## 参考资料

本项目基于 / 参考了以下公开材料（未随仓库分发）：

- [amosblomqvist/learn](https://github.com/amosblomqvist/learn) — 原始的教学系统（`teach` skill、三阶段流程、quiz/md-log 扩展、做图子代理）
- [mattpocock/skills](https://github.com/mattpocock/skills) — 通用技能库
- [yfrobotics/self-driving-handbook-cn](https://github.com/yfrobotics/self-driving-handbook-cn) — 分类分章的 handbook 组织方式参考
- 视频 *How I Use AI to Learn Things* — 整套系统的教学哲学来源

## 致谢

教学哲学与流程改编自 amosblomqvist/learn；本仓库做了这些适配：中文多领域、`pi-subagents` 子代理、`mermaid.ink`/`rsvg-convert` 做图自检、自适应学习者档案、以及发布到 Hugo 站点的复习笔记。
