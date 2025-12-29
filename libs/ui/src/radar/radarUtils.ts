import type { RadarRing } from "@xprtz/cms";

/**
 * Radar ring configuration with display order and radius positions
 * Ordered from center (Adopt) to outside (Hold)
 */
export const RINGS: readonly { readonly label: RadarRing; readonly radiusPosition: number }[] = [
  { label: "Adopt", radiusPosition: 25 },
  { label: "Trial", radiusPosition: 50 },
  { label: "Assess", radiusPosition: 75 },
  { label: "Hold", radiusPosition: 100 },
] as const;

/**
 * Builds a link to a radar item page with optional back navigation
 * @param slug - The slug of the radar item
 * @param parentPageSlug - Optional slug of the parent page for back navigation
 * @returns The full URL path to the radar item
 */
export function buildRadarItemLink(slug: string, parentPageSlug?: string): string {
  return parentPageSlug
    ? `/radar-items/${slug}?from=${encodeURIComponent(parentPageSlug)}`
    : `/radar-items/${slug}`;
}

/**
 * Initializes a callback function when the page is ready
 * Handles both Astro page-load events and initial page load
 * @param callback - The initialization function to execute
 */
export function initializeOnReady(callback: () => void): void {
  document.addEventListener("astro:page-load", callback);
  if (
    document.readyState === "complete" ||
    document.readyState === "interactive"
  ) {
    callback();
  }
}
