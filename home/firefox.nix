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
    :root {
      --lwt-accent-color: #${theme.background} !important;
      --toolbar-bgcolor: #${theme.background} !important;
      --tab-selected-bgcolor: #${theme.surface} !important;
      --toolbar-field-background-color: #${theme.surface} !important;
      --toolbar-field-focus-background-color: #${theme.surface} !important;
      --toolbar-field-focus-border-color: #${theme.accent} !important;
      --arrowpanel-background: #${theme.surface} !important;
    }
  '';
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

        settings = {
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "browser.theme.toolbar-theme" = 0;
          "browser.theme.content-theme" = 0;
          "layout.css.prefers-color-scheme.content-override" = 0;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome = themedChrome;
      };

      work = {
        id = 1;
      };
    };
  };
}
