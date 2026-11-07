// ==============================================================================
// Vortex Browser - Gecko Engine Core Preferences
// Hardened, Telemetry-Free, Container-Enabled, Custom-Chrome Activated
// ==============================================================================

// --- Enable Custom Chrome UI (userChrome.css / userContent.css) ---
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("layout.css.color-mix.enabled", true);
user_pref("layout.css.backdrop-filter.enabled", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);

// --- Window & UI Mechanics ---
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.closeWindowWithLastTab", true);
user_pref("browser.tabs.loadInBackground", true);
user_pref("browser.tabs.firefox-view", false);
user_pref("browser.tabs.tabmanager.enabled", false);
user_pref("full-screen-api.warning.timeout", 0);

// --- Multi-Account Spaces (Container Tabs) ---
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);
user_pref("privacy.userContext.longPressBehavior", 2);

// --- Hardware Acceleration & Smooth Motion ---
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.lines.durationMaxMS", 125);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);

// --- Privacy, Ad-Blocking & Tracking Protection ---
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("network.cookie.cookieBehavior", 5); // Total Cookie Protection

// --- Picture-in-Picture (Window-in-Window) Built-in Superpowers ---
user_pref("media.videocontrols.picture-in-picture.enabled", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.always-show", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.flyout-enabled", true);
user_pref("media.videocontrols.picture-in-picture.urlbar-button.enabled", true);
user_pref("media.videocontrols.picture-in-picture.keyboard-controls.enabled", true);
user_pref("media.videocontrols.picture-in-picture.display-text-tracks.enabled", true);
user_pref("media.videocontrols.picture-in-picture.auto-pip", true);
user_pref("media.videocontrols.picture-in-picture.respect-disablePictureInPicture", false);

// --- Disable Mozilla Telemetry, Studies & Sponsored Bloat ---
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("experiments.supported", false);
user_pref("experiments.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("extensions.pocket.enabled", false);
user_pref("identity.fxaccounts.enabled", true); // Keep Sync available if user desires

