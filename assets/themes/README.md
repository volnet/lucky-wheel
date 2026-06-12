# assets/themes/

Drop AI-generated background images in this directory. They show up as cards in **Settings → Theme**, and the active selection is persisted to `localStorage` under `luckyWheelTheme`.

## Recommended specs

Size (any of):

- `3840x2160` (4K)
- `2560x1440` (2K)
- `1920x1080` (FHD)

Format:

- `.png` (preferred — preserves transparency)
- `.jpg`
- `.webp`

> The page is a single static HTML file, so browsers cannot auto-discover files in this directory. After adding an image you must register it in the `themeCatalog` array in `index.html` for a card to appear.

## Built-in themes

| File                              | Theme ID                       | Display name     |
| --------------------------------- | ------------------------------ | ---------------- |
| *(none — uses the inline skin)*   | `default`                      | Default Stage    |
| `smart-parking-pk-arena.png`      | `smart-parking-pk-arena`       | Smart Arena      |
| `black-gold-pk-stage.png`         | `black-gold-pk-stage`          | Black Gold Stage |
| `gold-presentation-duel.png`      | `gold-presentation-duel`       | Golden Duel      |
| `blue-tech-pk-stage.png`          | `blue-tech-pk-stage`           | Blue Tech Stage  |
| `mecha-pk-battle.png`             | `mecha-pk-battle`              | Mecha Battle     |

## Adding a new theme

1. Drop the image into `assets/themes/`. Use a lowercase-kebab-case filename such as `mall-traffic-arena.png`.

2. Append an entry to the `themeCatalog` array near the top of `index.html`:

   ```js
   {
     id: "mall-traffic-arena",
     name: "Mall Traffic Arena",
     url: "assets/themes/mall-traffic-arena.png",
     skin: {
       bgDeep: "#0B1230",
       bgMid: "#1B2A6B",
       primary: "#3D6BFF",
       neon: "#5BE2FF",
       white: "#F0F7FF",
       accent: "#FFD86B",
       accentStrong: "#FFB800",
       danger: "#FF5577",
       panelRgb: "11, 18, 48",
       primaryRgb: "61, 107, 255",
       neonRgb: "91, 226, 255",
       accentRgb: "255, 216, 107",
       palette: [
         "#3D6BFF", "#5BE2FF", "#FFD86B", "#0B1230", "#FFB800",
         "#1B2A6B", "#F0F7FF", "#FF5577", "#7AB8FF", "#0E1B40"
       ]
     }
   }
   ```

3. Refresh the page. The new card appears in the grid; clicking it switches the wheel, the panels and the celebration palette to your colors.

### Skin field reference

| Field            | Type             | Description |
| ---------------- | ---------------- | ----------- |
| `bgDeep`         | hex color        | Deepest background tint (used in gradients). |
| `bgMid`          | hex color        | Mid background tint. |
| `primary`        | hex color        | Primary accent (glow, hub, button outlines). |
| `neon`           | hex color        | Secondary accent (panels, soft glows). |
| `white`          | hex color        | Highlight text color. |
| `accent`         | hex color        | Gold-style accent (most buttons and rings). |
| `accentStrong`   | hex color        | Stronger gold for hover/active states. |
| `danger`         | hex color        | Reset button and error highlights. |
| `panelRgb`       | `"R, G, B"`      | `bgDeep` as comma-separated RGB; used to build translucent panel fills. |
| `primaryRgb`     | `"R, G, B"`      | `primary` as comma-separated RGB. |
| `neonRgb`        | `"R, G, B"`      | `neon` as comma-separated RGB. |
| `accentRgb`      | `"R, G, B"`      | `accent` as comma-separated RGB. |
| `palette`        | hex color array  | 6–10 colors that drive the wheel segments, particles, confetti, and side fireworks. |

> Tip: the `*Rgb` strings let the CSS use `rgba(${skin.primaryRgb}, 0.42)` for translucent glows. Keep them in sync with the corresponding hex field.

## Tips for AI-generated backgrounds

- Avoid putting text, logos, buttons, faces, or wheels in the image. They will collide with the on-screen UI.
- Keep the central area (where the wheel is drawn) clean and slightly darker so the wheel pops.
- Reserve the edges and corners for atmosphere — neon, fog, sparks, light beams.
- Aim for a *stage* feel: high contrast, soft vignetting, balanced color temperature. Subtle is better than busy.
