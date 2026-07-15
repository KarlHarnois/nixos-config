{ ... }:

let
  theme = import ./theme.nix;

  ctrlNumberTabSwitching = "{84601290-bec9-494a-b11c-1baa897a9683}";
  vimium = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";

  forceInstalled = slug: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    installation_mode = "force_installed";
  };

  themedChrome = ''
    :root,
    #navigator-toolbox {
      --toolbox-background-color: #${theme.background} !important;
      --toolbar-background-color: #${theme.background} !important;
      --lwt-accent-color: #${theme.background} !important;
      --tab-background-color-selected: #${theme.surface} !important;
      --toolbar-field-background-color: #${theme.surface} !important;
      --input-bgcolor: #${theme.surface} !important;
      --smartbar-background-color: #${theme.surface} !important;
      --panel-background-color: #${theme.surface} !important;
      --focus-outline-color: #${theme.accent} !important;
      --urlbar-box-background-color: #${theme.surfaceLight} !important;
      --urlbar-box-background-color-focus: #${theme.surfaceLight} !important;
      --tabpanel-background-color: #${theme.background} !important;
    }

    #navigator-toolbox,
    #TabsToolbar,
    #nav-bar {
      background-color: #${theme.background} !important;
    }

    .tab-background[selected] {
      background-color: #${theme.surface} !important;
    }

    .urlbar-background,
    #searchbar {
      background-color: #${theme.surface} !important;
    }

    #tabbrowser-tabpanels,
    .browserContainer {
      background: #${theme.background} !important;
    }

    #urlbar-searchmode-switcher {
      background-color: #${theme.surfaceLight} !important;
    }
  '';

  emptyStartAndNewTabPage = {
    "browser.startup.homepage" = "about:blank";
    "browser.newtabpage.enabled" = false;
  };

  neverShowBookmarksBar."browser.toolbars.bookmarks.visibility" = "never";

  darkThemeSettings = {
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "browser.theme.toolbar-theme" = 0;
    "browser.theme.content-theme" = 0;
    "layout.css.prefers-color-scheme.content-override" = 0;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };
in
{
  programs.firefox = {
    enable = true;

    policies.ExtensionSettings = {
      ${ctrlNumberTabSwitching} = forceInstalled "ctrl-number-to-switch-tabs";
      ${vimium} = forceInstalled "vimium-ff";
    };

    profiles = {
      personal = {
        id = 0;
        isDefault = true;

        settings = emptyStartAndNewTabPage // darkThemeSettings // neverShowBookmarksBar;
        userChrome = themedChrome;
      };

      work = {
        id = 1;

        settings = emptyStartAndNewTabPage // darkThemeSettings // neverShowBookmarksBar;
        userChrome = themedChrome;
      };
    };
  };
}
