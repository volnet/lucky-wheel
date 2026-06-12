/*
 * Open-source default configuration for the Lucky Draw Wheel.
 *
 * Any field here can be overridden locally by creating config/local-config.js
 * (gitignored). When the page boots, the two files are merged so local values
 * take precedence. See config/local-config.example.js for the override shape.
 *
 *  - activityTitle : string    - main page title and <title> prefix
 *  - defaultTheme  : string    - one of the IDs in themeCatalog (index.html)
 *  - schemes       : string[]  - one proposal per entry
 *  - names         : string[]  - one candidate per entry (5-200 supported)
 *  - uiText        : object    - override any key from defaultUiText
 *
 * The defaults below use neutral English demo data so the open-source build
 * never ships personal or company-specific content.
 */

window.LUCKY_WHEEL_DEFAULT_CONFIG = {
  activityTitle: "Lucky Draw",
  defaultTheme: "default",
  schemes: [
    "Proposal A",
    "Proposal B"
  ],
  names: [
    "Alice",
    "Bob",
    "Carol",
    "Dan",
    "Erin",
    "Frank",
    "Grace",
    "Heidi"
  ]
};
