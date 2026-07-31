"use strict";

const STORAGE_KEY = "luckyWheelConfig";
const frame = document.getElementById("wheelFrame");

function sendToWheel(message) {
  if (frame.contentWindow) frame.contentWindow.postMessage(message, "*");
}

window.addEventListener("message", async (event) => {
  if (event.source !== frame.contentWindow || !event.data || event.data.source !== "lucky-wheel") return;

  const { action, requestId, config } = event.data;

  if (action === "load-config") {
    const stored = await chrome.storage.local.get(STORAGE_KEY);
    sendToWheel({
      source: "lucky-wheel-extension",
      action: "config-loaded",
      requestId,
      config: stored[STORAGE_KEY] || null
    });
    return;
  }

  if (action === "save-config" && config && typeof config === "object") {
    await chrome.storage.local.set({ [STORAGE_KEY]: config });
    sendToWheel({
      source: "lucky-wheel-extension",
      action: "config-saved",
      requestId
    });
    return;
  }

  if (action === "clear-config") {
    await chrome.storage.local.remove(STORAGE_KEY);
    sendToWheel({
      source: "lucky-wheel-extension",
      action: "config-cleared",
      requestId
    });
  }
});
