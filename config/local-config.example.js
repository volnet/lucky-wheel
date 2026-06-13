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
 *  - defaultTheme  : string    - one of the IDs in themeCatalog (index.html)
 *  - schemes       : string[]  - one proposal per entry
 *  - names         : string[]  - one candidate per entry (5-200 supported)
 *  - uiText        : object    - language packs, e.g. { en: {...}, zh: {...} }
 */

window.LUCKY_WHEEL_LOCAL_CONFIG = {
  // activityTitle: "Your Event Title",
  // defaultLanguage: "en",
  // defaultTheme: "blue-tech-pk-stage",
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
