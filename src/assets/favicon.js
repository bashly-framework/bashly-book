function getFaviconElement(type) {
  return document.querySelector(`link[rel="icon"][type="${type}"]`);
}

function getColorSchemeSuffix() {
  const prefersDarkColorScheme = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
  return prefersDarkColorScheme ? "-dark" : "";
}

export function syncFaviconToTheme() {
  const favicon = getFaviconElement("image/svg+xml");
  const faviconFallback = getFaviconElement("image/png");
  if (!favicon || !faviconFallback) {
    return;
  }

  const colorSchemeSuffix = getColorSchemeSuffix();
  const n = favicon.href.indexOf("-dark.svg");
  const newFaviconName = favicon.href.substr(0, n !== -1 ? n : favicon.href.lastIndexOf("."));
  favicon.href = `${newFaviconName}${colorSchemeSuffix}.svg`;
  faviconFallback.href = `${newFaviconName}${colorSchemeSuffix}.png`;
}

syncFaviconToTheme();
window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => {
  syncFaviconToTheme();
});
