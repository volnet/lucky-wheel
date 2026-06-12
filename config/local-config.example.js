/*
 * Personal override template.
 *
 *   1. Copy this file to config/local-config.js (same directory).
 *   2. Edit the values to fit your event.
 *   3. config/local-config.js is gitignored, so your private data stays local.
 *
 * The shape mirrors config/default-config.js. Every field is optional; missing
 * fields fall back to the open-source defaults. uiText keys are also optional;
 * any key you omit falls back to the English defaults baked into index.html.
 *
 *  - activityTitle : string    - main page title and <title> prefix
 *  - defaultTheme  : string    - one of the IDs in themeCatalog (index.html)
 *  - schemes       : string[]  - one proposal per entry
 *  - names         : string[]  - one candidate per entry (5-200 supported)
 *  - uiText        : object    - override any key from defaultUiText
 */

window.LUCKY_WHEEL_LOCAL_CONFIG = {
  // activityTitle: "Your Event Title",
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
  //   // Override any key here. The English defaults live in index.html.
  //   // activitySectionTitle: "Event",
  // }
};
