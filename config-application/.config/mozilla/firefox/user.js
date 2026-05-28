// Hide search bar
user_pref("browser.newtabpage.activity-stream.showSearch", false);
 
// Hide weather widget (both prefs required)
user_pref("browser.newtabpage.activity-stream.showWeather", false);
user_pref("browser.newtabpage.activity-stream.system.showWeather", false);
 
// Hide shortcuts / top sites
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
 
// Hide Pocket / Discover stories
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
 
// Hide sponsored tiles and content
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
 
// Disable telemetry/pings from new tab
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
 
// Never ask to set Firefox as default browser
user_pref("browser.shell.checkDefaultBrowser", false);
 
// Enable userChrome.css/userContent.css customizations
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
 
// Show compact mode option in customize toolbar menu
user_pref("browser.compactmode.show", true);
 
// Use KDE/XDG file picker instead of GTK (KDE integration)
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
 
// Enable compact density (officially "unsupported" but still works)
user_pref("browser.uidensity", 1);
 
// Disable cosmetic animations
user_pref("toolkit.cosmeticAnimations.enabled", false);
 
// Disable AI link preview
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.linkPreview.longPress", false);
 
// Allow unsigned extensions
user_pref("xpinstall.signatures.required", false);
