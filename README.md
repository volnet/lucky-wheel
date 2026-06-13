# Lucky Draw Wheel

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
| `defaultTheme`  | `string`   | One of the IDs from `themeCatalog` in `index.html`. Falls back to `default` if unknown. |
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

The theme catalog lives in `themeCatalog` near the top of `index.html`. Each entry has:

- `id` — the persisted key written to `localStorage`.
- `name` — display name on the theme card.
- `url` — path to the background image; `null` means no image (use the inline color skin).
- `skin` — color palette that drives the wheel, buttons, panels, particles and confetti.

The six built-in themes:

| ID                          | Display name     | Background image                       |
| --------------------------- | ---------------- | -------------------------------------- |
| `default`                   | Default Stage    | *(uses the blue-gold skin, no image)*  |
| `black-gold-pk-stage`       | Black Gold Stage | `assets/themes/black-gold-pk-stage.png` |
| `smart-parking-pk-arena`    | Smart Arena      | `assets/themes/smart-parking-pk-arena.png` |
| `gold-presentation-duel`    | Golden Duel      | `assets/themes/gold-presentation-duel.png` |
| `blue-tech-pk-stage`        | Blue Tech Stage  | `assets/themes/blue-tech-pk-stage.png` |
| `mecha-pk-battle`           | Mecha Battle     | `assets/themes/mecha-pk-battle.png`    |

Add your own by dropping a PNG into `assets/themes/` and appending a matching entry to `themeCatalog` near the top of `index.html`. A theme entry contains:

```js
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
```

Keep theme names and committed assets generic. Put private event imagery outside the repo or in a gitignored local branch if it should not be published.

## Keyboard shortcuts

| Key            | Action                                  |
| -------------- | --------------------------------------- |
| <kbd>Space</kbd>  | Start Draw *(suppressed while typing)* |
| <kbd>R</kbd> / <kbd>r</kbd> | Reset All *(suppressed while typing)* |
| <kbd>Esc</kbd>    | Close the winner modal                |

## Importing candidates

The **Import & Tips** section in the settings panel accepts `.txt` or `.csv` files. The parser splits on newlines, commas, tabs, semicolons, and the full-width forms of those separators, then deduplicates case-insensitively and trims whitespace. It expects 5–200 entries; the page surfaces the validator message inline.

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
