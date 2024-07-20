// Firefox Autoconfig Defaults

// Skip Welcome
lockPref("browser.aboutwelcome.enabled", false);

// Disable about:config warning
lockPref("browser.aboutConfig.showWarning", false);

// Disable Default Browser Check
lockPref("browser.shell.checkDefaultBrowser", false);

// Language
lockPref("intl.accept_languages", "en-US, en, nl");

// Black Theme
lockPref("browser.theme.content-theme", 0);
lockPref("browser.theme.toolbar-theme", 0);
lockPref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
lockPref("layout.css.prefers-color-scheme.content-override", 0);

// Blank Page
lockPref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
lockPref("browser.newtabpage.activity-stream.feeds.topsites", false);
lockPref("browser.newtabpage.activity-stream.showSearch", false);
lockPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
lockPref("browser.newtabpage.enabled", false);

lockPref("browser.toolbars.bookmarks.visibility", "newtab");

// Disable Spell Checker
lockPref("layout.spellcheckDefault", 0);

// Disable Translations
lockPref("browser.translations.enable", false);
lockPref("browser.translations.automaticallyPopup", false);
lockPref("browser.translations.panelShown", true);

// Disable Pocket
lockPref("extensions.pocket.enabled", false);

// Disable Recent Documents
lockPref("browser.download.manager.addToRecentDocs", false);

// Disable PDFJS scripting
lockPref("pdfjs.enableScripting", false);

// Enable DRM
lockPref("media.eme.enabled", true);

// Default Performance Settings
lockPref("browser.preferences.defaultPerformanceSettings.enabled", true);

// Browsing Settings
lockPref("media.hardwaremediakeys.enabled", false);
lockPref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Do Not Track
lockPref("privacy.donottrackheader.enabled", true);
lockPref("privacy.globalprivacycontrol.enabled", true);

// Browser Privacy
lockPref("browser.contentblocking.category", "strict");

// Disable Sign On
lockPref("signon.autofillForms", false);
lockPref("signon.firefoxRelay.feature", "disabled");
lockPref("signon.generation.enabled", false);
lockPref("signon.management.page.breach-alerts.enabled", false);
lockPref("signon.rememberSignons", false);
lockPref("dom.forms.autocomplete.formautofill", false);

// Disable Data Collection
lockPref("datareporting.healthreport.uploadEnabled", false);
lockPref("browser.discovery.enabled", false);
lockPref("app.shield.optoutstudies.enabled", false);
lockPref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
lockPref("datareporting.policy.dataSubmissionEnabled", false);
lockPref("toolkit.telemetry.enabled", false);
lockPref("toolkit.telemetry.unified", false);
lockPref("toolkit.telemetry.server", "data:,");
lockPref("toolkit.telemetry.archive.enabled", false);
lockPref("toolkit.telemetry.newProfilePing.enabled", false);
lockPref("toolkit.telemetry.shutdownPingSender.enabled", false);
lockPref("toolkit.telemetry.updatePing.enabled", false);
lockPref("toolkit.telemetry.bhrPing.enabled", false);
lockPref("toolkit.telemetry.firstShutdownPing.enabled", false);
lockPref("toolkit.telemetry.coverage.opt-out", true);
lockPref("toolkit.coverage.opt-out", true);
lockPref("toolkit.coverage.endpoint.base.", "");
lockPref("browser.ping-centre.telemetry", false);
lockPref("beacon.enabled", false);
lockPref("app.normandy.enabled", false);
lockPref("app.normandy.api_url", "");

// Disable Crash Reports
lockPref("breakpad.reportURL", "");
lockPref("browser.tabs.crashReporting.sendReport", false);

// Disable Website Advertising
lockPref("dom.private-attribution.submission.enabled", false);

// Disable Captive Portal
lockPref("captivedetect.canonicalURL", "");
lockPref("network.captive-portal-service.enabled", false);

// Disable Network Connections Service
lockPref("network.connectivity-service.enabled", false);

// Force HTTPS
lockPref("dom.security.https_only_mode", true);

// Disable DNS over HTTPS
lockPref("doh-rollout.disable-heuristics", true);
lockPref("network.trr.mode", 5);

// Disable WebRTC
lockPref("media.peerconnection.enabled", false);
lockPref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
lockPref("media.peerconnection.ice.default_address_only", true);
lockPref("media.peerconnection.ice.no_host", true);
lockPref("webgl.disabled", true);
lockPref("media.autoplay.default", 5);

// Disabe XDG Desktop Usage
lockPref("widget.use-xdg-desktop-portal.file-picker", 0);
lockPref("widget.use-xdg-desktop-portal.location", 0);
lockPref("widget.use-xdg-desktop-portal.mime-handler", 0);
lockPref("widget.use-xdg-desktop-portal.native-messaging", 0);
lockPref("widget.use-xdg-desktop-portal.open-uri", 0);
lockPref("widget.use-xdg-desktop-portal.settings", 0);

// Disable activity stream on new windows and tab pages
lockPref("browser.newtabpage.enabled", false);
lockPref("browser.newtab.preload", false);
lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
lockPref("browser.newtabpage.activity-stream.telemetry", false);
lockPref("browser.newtabpage.activity-stream.feeds.snippets", false);
lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
lockPref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
lockPref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
lockPref("browser.newtabpage.activity-stream.showSponsored", false);
lockPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
lockPref("browser.newtabpage.activity-stream.default.sites", "");

// Layout
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"save-to-pocket-button\",\"downloads-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":20,\"newElementCount\":2}");
