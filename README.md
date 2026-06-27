# Lucky Draw Wheel

<p align="center">
  <a href="#lucky-draw-wheel">English</a> |
  <a href="#中文说明">中文</a>
</p>

A single-file HTML lucky-draw wheel for live events. Drop it on a thumb drive, double-click `index.html`, and you have a self-contained, offline-capable draw machine with a dual-ring spinner, bilingual interface text, voice announcements, confetti and side-fireworks.

Built for stage presentations, raffles, classroom picks, team standups, ice-breakers, and any moment that needs a fair, visible, and dramatic random pick.

## Highlights

- **One file, no build.** All HTML, CSS and JavaScript are inlined in `index.html`.
- **Offline by default.** No CDN, no network calls, no telemetry. Web Audio synthesizes every sound effect on the fly.
- **Dual-ring wheel.** Inner ring spins clockwise through candidates; outer ring spins counter-clockwise through proposals. Add one proposal and the outer ring auto-hides.
- **5–200 candidates.** Bounded by a single validator that tells you what to fix.
- **Anti-duplicate.** Already-drawn candidates stay visible as dimmed completed segments; if the wheel lands on one, it auto re-spins.
- **Live status.** Total / Remaining / Drawn counters, a drawn-names list and a per-draw history with timestamps.
- **Theme system.** Six built-in themes, each with its own background image and color skin. Theme choice is persisted to `localStorage`.
- **Bilingual UI.** English and Chinese language packs are built in. The language selector is available in the settings panel and can be extended for other locales.
- **Browser TTS.** Announces the winner through the OS speech synthesizer (zh-CN voice is used when available, otherwise the system default).
- **Confetti + side fireworks.** The full-screen celebration runs on its own canvas with no third-party libs.
- **CSV export.** UTF-8 with BOM, friendly to Excel and Google Sheets.
- **Keyboard friendly.** <kbd>Space</kbd> draws, <kbd>R</kbd> resets, <kbd>Esc</kbd> closes the winner modal.
- **Responsive.** Adapts down to ~720 px wide; the settings panel collapses to a tab when space is tight.

## Quick start

1. Double-click `index.html`.
2. Open the **Settings** panel on the right.
3. Choose **English** or **中文** in the **Language** section.
4. Type a list of candidates (one per line; 5 to 200 entries).
5. Optionally type a list of proposals.
6. Click **Build Wheel**.
7. Press <kbd>Space</kbd> or click **Start Draw**.

## Controls

| Button           | Action                                                                 |
| ---------------- | ---------------------------------------------------------------------- |
| Build Wheel      | Re-parse the title, proposals and candidates, then redraw the wheel.   |
| Start Draw       | Spin the wheel and reveal the winner.                                  |
| Reset All        | Clear the drawn set and history.                                       |
| Fullscreen       | Toggle browser fullscreen. Label switches to *Exit Fullscreen* on use. |
| Export CSV       | Download the draw history as a UTF-8 CSV file.                         |
| Shuffle List     | Fisher-Yates shuffle the candidate list and rebuild.                  |
| Clear List       | Empty the candidate input (you must re-enter names and rebuild).       |

The round hub in the centre of the wheel is the same trigger as **Start Draw**.

## Configure for your event

The committed files should stay generic. Your event title, real candidate names, industry wording, theme choice and any private scenario text should live in `config/local-config.js`. That file is **gitignored**, so it never leaves your machine and does not ship in the open-source version.

```text
config/
├── default-config.js         # committed; neutral English demo data
├── local-config.example.js   # committed; template
└── local-config.js           # gitignored; your personal overrides
```

### Local override workflow

1. Copy the template:
   ```bash
   cp config/local-config.example.js config/local-config.js
   ```
2. Edit the values in `config/local-config.js`. Every field is optional; missing fields fall back to `default-config.js`.
3. Refresh the page. Local values override defaults; `uiText` language packs merge on top of `config/default-config.js`.

Example `config/local-config.js`:

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  activityTitle: "2026 Solution Championship",
  defaultLanguage: "en",
  defaultTheme: "blue-tech-pk-stage",
  schemes: [
    "Smart Parking",
    "Customer Flow Analytics",
    "Digital Twin"
  ],
  names: [
    "Avery",
    "Blair",
    "Cameron"
    // ...
  ],
  uiText: {
    en: {
      startButton: "Start Battle",
      winnerTitle: "Selected Presenter",
      winnerMessage: "You are selected for the next presentation."
    },
    zh: {
      startButton: "开始比拼",
      winnerTitle: "荣耀揭晓",
      winnerMessage: "获得本轮讲解机会"
    }
  }
};
```

### Why split the config?

| File                       | Purpose                              | Committed? |
| -------------------------- | ------------------------------------ | ---------- |
| `default-config.js`        | Neutral demo data and language packs shipped to users. | Yes        |
| `local-config.example.js`  | Schema template for personal config. | Yes        |
| `local-config.js`          | Your private overrides.              | No         |

This means publishing the repo never exposes your event title, candidate names, internal project names or any other personal data — even by accident.

## Configuration reference

`default-config.js` and `local-config.js` share the same shape:

| Field           | Type       | Description |
| --------------- | ---------- | ----------- |
| `activityTitle` | `string`   | Main page heading and `<title>` text. |
| `defaultLanguage` | `string` | Default UI language key, such as `en` or `zh`. Users can still switch language in the settings panel. |
| `defaultTheme`  | `string`   | One of the IDs in `themes`. Falls back to `default` if unknown. |
| `themes`        | `object[]` | Theme backgrounds and color skins. Local themes append or override committed themes by `id`. |
| `schemes`       | `string[]` | One proposal per entry. Joined with `\n` in the textarea. |
| `names`         | `string[]` | One candidate per entry. Joined with `\n` in the textarea. 5–200 supported. |
| `uiText`        | `object`   | Optional language packs, for example `{ en: {...}, zh: {...} }`. Override only the labels you need. |

### Language packs

English and Chinese are included by default. Add another language by adding a new key to `uiText` and setting `defaultLanguage` to that key:

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  defaultLanguage: "ja",
  uiText: {
    ja: {
      generateButton: "ホイール作成",
      startButton: "抽選開始",
      winnerTitle: "当選者"
    }
  }
};
```

Missing labels fall back to the English defaults, so a partial translation is valid while you iterate.

## Adapt to a theme or industry

Use `local-config.js` for event-specific configuration and keep committed defaults neutral.

1. Choose a visual base with `defaultTheme`.
2. Set `activityTitle` to the event title shown on stage.
3. Put your industries, proposals, sessions or presentation topics in `schemes`.
4. Put candidates in `names`.
5. Override visible wording in `uiText.en`, `uiText.zh`, or another language pack.
6. Add a background image under `assets/themes/` when the built-in images do not fit the event.

Example for an AI parking solution event:

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  activityTitle: "AI Parking Solution Battle",
  defaultLanguage: "en",
  defaultTheme: "smart-parking-pk-arena",
  schemes: [
    "Smart Parking Guidance",
    "Mall Traffic Analytics",
    "Digital Twin Operations"
  ],
  uiText: {
    en: {
      schemeSectionTitle: "Solution Tracks",
      winnerMessage: "You are selected for the next solution presentation."
    },
    zh: {
      schemeSectionTitle: "方案赛道",
      winnerMessage: "获得本轮方案讲解机会"
    }
  }
};
```

> **Privacy note:** if your repository's history ever contained personal data, run `git filter-repo` (or BFG) before publishing. The split above only protects the working tree from then on.

## Themes

The built-in theme catalog lives in `config/default-config.js`. Add event-specific themes to the `themes` array in `config/local-config.js`; no `index.html` changes are required. Each entry has:

- `id` — the persisted key written to `localStorage`.
- `name` — display name on the theme card.
- `url` — path to the background image; `null` means no image (use the inline color skin).
- `skin` — color palette that drives the wheel, buttons, panels, particles and confetti.

The seven built-in themes:

| ID                          | Display name     | Background image                       |
| --------------------------- | ---------------- | -------------------------------------- |
| `default`                   | Default Stage    | *(uses the blue-gold skin, no image)*  |
| `black-gold-pk-stage`       | Black Gold Stage | `assets/themes/black-gold-pk-stage.png` |
| `smart-parking-pk-arena`    | Smart Arena      | `assets/themes/smart-parking-pk-arena.png` |
| `gold-presentation-duel`    | Golden Duel      | `assets/themes/gold-presentation-duel.png` |
| `blue-tech-pk-stage`        | Blue Tech Stage  | `assets/themes/blue-tech-pk-stage.png` |
| `ai-traffic`                | AI Traffic       | `assets/themes/ai-traffic.png` |
| `mecha-pk-battle`           | Mecha Battle     | `assets/themes/mecha-pk-battle.png`    |

Add your own by dropping a PNG into `assets/themes/` and appending a matching entry to `themes` in `config/local-config.js`:

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  defaultTheme: "your-industry-stage",
  themes: [
    {
      id: "your-industry-stage",
      name: "Your Industry Stage",
      url: "assets/themes/your-industry-stage.png",
      skin: {
        bgDeep: "#061B4D",
        bgMid: "#081F57",
        primary: "#1F6FFF",
        neon: "#4AA8FF",
        white: "#EAF4FF",
        accent: "#FFD86B",
        accentStrong: "#FFB800",
        danger: "#FF477E",
        panelRgb: "6, 27, 77",
        primaryRgb: "31, 111, 255",
        neonRgb: "74, 168, 255",
        accentRgb: "255, 216, 107",
        palette: ["#0A47FF", "#1F6FFF", "#4AA8FF", "#FFD86B"]
      }
    }
  ]
};
```

Themes are merged by `id`. A local theme with a new `id` is appended; a local theme with an existing `id` overrides that theme. Partial `skin` overrides inherit all omitted color fields. Keep private event imagery outside the repo or ignore it with `.gitignore` if it should not be published.

## Keyboard shortcuts

| Key            | Action                                  |
| -------------- | --------------------------------------- |
| <kbd>Space</kbd>  | Start Draw *(suppressed while typing)* |
| <kbd>R</kbd> / <kbd>r</kbd> | Reset All *(suppressed while typing)* |
| <kbd>Esc</kbd>    | Close the winner modal                |

## Importing candidates

The **Import & Tips** section in the settings panel accepts `.txt` or `.csv` files. The parser splits on newlines, commas, tabs, semicolons, and the full-width forms of those separators, then deduplicates case-insensitively and trims whitespace. It expects 5–200 entries; the page surfaces the validator message inline.

Example `names.txt`:

```text
Alice
Bob
Carol
Dan
Erin
```

Example `names.csv`:

```csv
Alice,Bob,Carol,Dan,Erin
```

`.xlsx` / `.xls` files are rejected with a hint to re-save as CSV from Excel first — the offline build does not bundle an Excel parser.

## CSV export

The **Export CSV** button writes a UTF-8 with BOM CSV of the current draw history. Columns:

```text
#,Name,Proposal,Drawn At
1,Avery,Project Atlas,2026/06/13 14:32:08
2,Blair,Project Beacon,2026/06/13 14:33:41
```

Files are named `lucky-draw_YYYYMMDD_HHMMSS.csv`.

## Project layout

```text
.
├── index.html                       # everything: HTML, CSS, JavaScript
├── config/
│   ├── default-config.js            # committed, neutral English defaults
│   ├── local-config.example.js      # committed, override template
│   └── local-config.js              # gitignored, your private overrides
├── assets/
│   └── themes/                      # theme background images
│       ├── ai-traffic.png
│       ├── black-gold-pk-stage.png
│       ├── blue-tech-pk-stage.png
│       ├── gold-presentation-duel.png
│       ├── mecha-pk-battle.png
│       └── smart-parking-pk-arena.png
├── .gitignore
└── README.md
```

## License

MIT. See `LICENSE` (add one if you publish the repo) or substitute your own.

## Version control

This directory is its own Git repository. Common commands:

```bash
git status
git log --oneline
git diff
```

---

# 中文说明

<p align="center">
  <a href="#lucky-draw-wheel">English</a> |
  <a href="#中文说明">中文</a>
</p>

Lucky Draw Wheel 是一个单文件 HTML 抽签大转盘，适合公司活动、方案评审、课堂点名、年会抽奖、团队分享等现场场景。双击 `index.html` 即可运行，不需要后端服务，也不依赖 CDN。

## 功能亮点

- **单文件运行。** HTML、CSS、JavaScript 全部内嵌在 `index.html`。
- **离线可用。** 无网络请求、无遥测；音效由浏览器 Web Audio 合成。
- **双圈转盘。** 内圈抽候选人，外圈抽方案；只有一个方案时外圈自动隐藏。
- **5–200 人名单。** 内置校验和错误提示。
- **防重复。** 已抽中过的人会保留在转盘上，并显示为已完成状态；再次抽中会自动重抽。
- **主题系统。** 内置多套背景图和配色皮肤，也支持新增行业主题。
- **中英双语。** 界面内置 English / 中文，并支持扩展更多语言。
- **语音播报。** 抽中后使用浏览器语音播报结果。
- **结果导出。** 支持导出 UTF-8 CSV，方便 Excel 打开。
- **快捷键。** 空格开始抽签，`R` 重置，`Esc` 关闭结果弹窗。

## 快速开始

1. 双击打开 `index.html`。
2. 打开右侧 **Settings / 配置** 面板。
3. 在 **Language / 界面语言** 中选择 English 或 中文。
4. 在候选人名单中输入名字，每行一个，支持 5–200 人。
5. 可选：在方案列表中输入方案、赛道、主题或议题。
6. 点击 **Build Wheel / 生成转盘**。
7. 点击 **Start Draw / 开始抽签**，或按空格键开始。

## 导入与提示是什么

**导入与提示** 区域用于两件事：

1. 从 `.txt` 或 `.csv` 文件导入候选人名单。
2. 显示快捷键提示和名单格式示例。

导入规则：

- 支持 `.txt`、`.csv`。
- 可以每行一个名字。
- 也可以使用英文逗号、中文逗号、分号、Tab 分隔。
- 会自动去掉空白并按大小写不敏感去重。
- 需要 5–200 个候选人。
- `.xlsx` / `.xls` 不会直接解析；请先在 Excel 中另存为 CSV，再导入。

示例 `names.txt`：

```text
张三
李四
王五
赵六
钱七
```

示例 `names.csv`：

```csv
张三,李四,王五,赵六,钱七
```

## 为你的活动做配置

开源仓库里的默认内容应该保持通用。真实活动标题、候选人名单、行业术语、私有主题等内容建议写入 `config/local-config.js`。这个文件已经被 `.gitignore` 忽略，不会被提交到开源仓库。

```text
config/
├── default-config.js         # 提交到仓库，通用默认配置
├── local-config.example.js   # 提交到仓库，本地配置模板
└── local-config.js           # 不提交，本地私有配置
```

本地配置流程：

1. 复制模板：
   ```bash
   cp config/local-config.example.js config/local-config.js
   ```
2. 修改 `config/local-config.js`。
3. 刷新页面，本地配置会覆盖默认配置。

示例：

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  activityTitle: "2026 Solution Championship",
  defaultLanguage: "zh",
  defaultTheme: "blue-tech-pk-stage",
  schemes: [
    "Smart Parking",
    "Customer Flow Analytics",
    "Digital Twin"
  ],
  names: [
    "Alice",
    "Blair",
    "Cameron",
    "Devon",
    "Elliot"
  ],
  uiText: {
    en: {
      startButton: "Start Battle",
      winnerTitle: "Selected Presenter"
    },
    zh: {
      startButton: "开始比拼",
      winnerTitle: "荣耀揭晓"
    }
  }
};
```

## 配置项说明

| 字段 | 类型 | 说明 |
| ---- | ---- | ---- |
| `activityTitle` | `string` | 页面主标题和浏览器标题。 |
| `defaultLanguage` | `string` | 默认界面语言，例如 `en` 或 `zh`。用户仍可在界面中切换。 |
| `defaultTheme` | `string` | 默认主题 ID，来源于 `themes`。 |
| `themes` | `object[]` | 主题背景和配色。本地主题会按 `id` 追加或覆盖默认主题。 |
| `schemes` | `string[]` | 方案、赛道、议题或主题列表。每项对应外圈一个扇区。 |
| `names` | `string[]` | 候选人名单，支持 5–200 人。 |
| `uiText` | `object` | 界面文案语言包，例如 `{ en: {...}, zh: {...} }`。只覆盖需要修改的字段即可。 |

## 适配行业或主题

如果要把通用开源版改成某个行业或活动场景，推荐只改配置，不把私有内容提交进仓库：

1. 用 `activityTitle` 设置活动标题。
2. 用 `defaultTheme` 选择内置视觉主题。
3. 用 `schemes` 填入行业方案、赛道、议题或产品模块。
4. 用 `names` 填入候选人名单。
5. 用 `uiText.en`、`uiText.zh` 覆盖界面文案。
6. 如需专属视觉，把背景图放入 `assets/themes/`，再在 `config/local-config.js` 的 `themes` 中登记，无需修改 `index.html`。

AI 停车方案场景示例：

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  activityTitle: "AI Parking Solution Battle",
  defaultLanguage: "en",
  defaultTheme: "smart-parking-pk-arena",
  schemes: [
    "Smart Parking Guidance",
    "Mall Traffic Analytics",
    "Digital Twin Operations"
  ],
  uiText: {
    en: {
      schemeSectionTitle: "Solution Tracks",
      winnerMessage: "You are selected for the next solution presentation."
    },
    zh: {
      schemeSectionTitle: "方案赛道",
      winnerMessage: "获得本轮方案讲解机会"
    }
  }
};
```

## 主题扩展

内置主题列表位于 `config/default-config.js`。活动专属主题应配置在 `config/local-config.js` 的 `themes` 数组中，无需修改主程序。每个主题包含：

- `id`：主题唯一标识，会写入 `localStorage`。
- `name`：界面上显示的主题名。
- `url`：背景图路径，通常放在 `assets/themes/`。
- `skin`：控制转盘、按钮、面板、粒子和彩带的配色。

新增主题示例：

```js
window.LUCKY_WHEEL_LOCAL_CONFIG = {
  defaultTheme: "your-industry-stage",
  themes: [
    {
      id: "your-industry-stage",
      name: "Your Industry Stage",
      url: "assets/themes/your-industry-stage.png",
      skin: {
        bgDeep: "#061B4D",
        bgMid: "#081F57",
        primary: "#1F6FFF",
        neon: "#4AA8FF",
        white: "#EAF4FF",
        accent: "#FFD86B",
        accentStrong: "#FFB800",
        danger: "#FF477E",
        panelRgb: "6, 27, 77",
        primaryRgb: "31, 111, 255",
        neonRgb: "74, 168, 255",
        accentRgb: "255, 216, 107",
        palette: ["#0A47FF", "#1F6FFF", "#4AA8FF", "#FFD86B"]
      }
    }
  ]
};
```

主题按 `id` 合并：新 `id` 会新增主题，相同 `id` 会覆盖默认主题。只覆盖部分 `skin` 字段时，其余颜色会自动继承原主题。

## 导出结果

点击 **Export CSV / 导出结果 CSV** 会导出当前抽签历史，格式为 UTF-8 with BOM，Excel 可以直接打开。

```text
#,Name,Proposal,Drawn At
1,Avery,Project Atlas,2026/06/13 14:32:08
2,Blair,Project Beacon,2026/06/13 14:33:41
```

## 项目结构

```text
.
├── index.html
├── config/
│   ├── default-config.js
│   ├── local-config.example.js
│   └── local-config.js
├── assets/
│   └── themes/
├── .gitignore
└── README.md
```

## 版本管理

常用命令：

```bash
git status
git log --oneline
git diff
```
