/*
 * Personal override template.
 *
 *   1. Copy this file to config/local-config.js (same directory).
 *   2. Edit the values to fit your event.
 *   3. config/local-config.js is gitignored, so your private data stays local.
 *
 * The shape mirrors config/default-config.js. Every field is optional; missing
 * fields fall back to the open-source defaults. uiText language packs are also
 * optional; any key you omit falls back to the matching default language pack.
 *
 *  - activityTitle : string    - main page title and <title> prefix
 *  - defaultLanguage : string  - "en", "zh", or another language key you add
 *  - defaultTheme  : string    - one of the IDs in themes
 *  - themes        : object[]  - append themes or override defaults by ID
 *  - schemes       : string[]  - one proposal per entry
 *  - names         : string[]  - one candidate per entry (5-200 supported)
 *  - uiText        : object    - language packs, e.g. { en: {...}, zh: {...} }
 */

window.LUCKY_WHEEL_LOCAL_CONFIG = {
  // activityTitle: "Your Event Title",
  // defaultLanguage: "en",
  // defaultTheme: "your-industry-stage",
  // themes: [
  //   {
  //     id: "your-industry-stage",
  //     name: "Your Industry Stage",
  //     url: "assets/themes/your-industry-stage.png",
  //     skin: {
  //       bgDeep: "#071426",
  //       bgMid: "#0B2B52",
  //       primary: "#1F6FFF",
  //       neon: "#4ADFFF",
  //       white: "#F3FAFF",
  //       accent: "#FFD86B",
  //       accentStrong: "#FFB800",
  //       danger: "#FF477E",
  //       panelRgb: "7, 20, 38",
  //       primaryRgb: "31, 111, 255",
  //       neonRgb: "74, 223, 255",
  //       accentRgb: "255, 216, 107",
  //       palette: ["#1F6FFF", "#4ADFFF", "#0B2B52", "#FFD86B", "#F3FAFF"]
  //     }
  //   }
  // ],
  // schemes: [
  //   "Your Proposal A",
  //   "Your Proposal B"
  // ],
  // names: [
  //   "Person One",
  //   "Person Two"
  // ],
  // uiText: {
  //   // Override only the labels your event needs. Missing keys fall back to
  //   // config/default-config.js and then the baked-in English defaults.
  //   en: {
  //     activitySectionTitle: "Event",
  //     winnerTitle: "Selected"
  //   },
  //   zh: {
  //     activitySectionTitle: "活动配置",
  //     winnerTitle: "荣耀揭晓"
  //   }
  // }
};
