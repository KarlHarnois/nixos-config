{ theme, ... }:

let
  ctrlNumberTabSwitching = "{84601290-bec9-494a-b11c-1baa897a9683}";
  onePassword = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
  vimium = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";

  forceInstalled = slug: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    installation_mode = "force_installed";
  };

  themedChrome = ''
    :root,
    #navigator-toolbox {
      --toolbox-background-color: #${theme.palette.background} !important;
      --toolbar-background-color: #${theme.palette.background} !important;
      --lwt-accent-color: #${theme.palette.background} !important;
      --tab-background-color-selected: #${theme.palette.surface} !important;
      --toolbar-field-background-color: #${theme.palette.surface} !important;
      --input-bgcolor: #${theme.palette.surface} !important;
      --smartbar-background-color: #${theme.palette.surface} !important;
      --panel-background-color: #${theme.palette.surface} !important;
      --focus-outline-color: #${theme.palette.accent} !important;
      --urlbar-box-background-color: #${theme.palette.surfaceLight} !important;
      --urlbar-box-background-color-focus: #${theme.palette.surfaceLight} !important;
      --tabpanel-background-color: #${theme.palette.background} !important;
    }

    #navigator-toolbox,
    #TabsToolbar,
    #nav-bar {
      background-color: #${theme.palette.background} !important;
    }

    .tab-background[selected] {
      background-color: #${theme.palette.surface} !important;
    }

    .urlbar-background,
    #searchbar {
      background-color: #${theme.palette.surface} !important;
    }

    #tabbrowser-tabpanels,
    .browserContainer {
      background: #${theme.palette.background} !important;
    }

    #urlbar-searchmode-switcher {
      background-color: #${theme.palette.surfaceLight} !important;
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

  profileDefaults = {
    settings = emptyStartAndNewTabPage // darkThemeSettings // neverShowBookmarksBar;
    userChrome = themedChrome;
  };
in
{
  programs.firefox = {
    enable = true;

    policies.ExtensionSettings = {
      ${ctrlNumberTabSwitching} = forceInstalled "ctrl-number-to-switch-tabs";
      ${onePassword} = forceInstalled "1password-x-password-manager";
      ${vimium} = forceInstalled "vimium-ff";
    };

    profiles = {
      personal = profileDefaults // {
        id = 0;
        isDefault = true;
      };

      work = profileDefaults // {
        id = 1;
      };
    };
  };
}
