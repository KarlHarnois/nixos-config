{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (osConfig) theme;

  pickerStylesheet = pkgs.writeText "hyprland-preview-share-picker.css" ''
    @define-color foreground ${theme.palette.foreground.hex};
    @define-color background ${theme.palette.background.hex};
    @define-color accent ${theme.palette.accent.hex};
    @define-color muted ${theme.palette.separator.hex};
    @define-color card_bg ${theme.palette.surface.hex};
    @define-color on_accent ${theme.palette.background.hex};
    @define-color accent_hover ${theme.palette.surfaceLight.hex};

    * {
      all: unset;
      font-family: ${theme.font};
      color: @foreground;
      font-weight: bold;
      font-size: 16px;
    }

    .window {
      background: alpha(@background, 0.95);
      border: solid 1px @accent;
      margin: 4px;
      padding: 18px;
    }

    tabs {
      padding: 0.5rem 1rem;
    }

    tabs > tab {
      margin-right: 1rem;
    }

    .tab-label {
      color: @foreground;
      transition: all 0.2s ease;
    }

    tabs > tab:checked > .tab-label,
    tabs > tab:active > .tab-label {
      text-decoration: underline currentColor;
      color: @accent;
    }

    tabs > tab:focus > .tab-label {
      color: @foreground;
    }

    .page {
      padding: 1rem;
    }

    .image-label {
      font-size: 12px;
      padding: 0.25rem;
    }

    flowboxchild > .card,
    button > .card {
      transition: all 0.2s ease;
      border: solid 1px transparent;
      border-color: @background;
      border-radius: 5px;
      background-color: @card_bg;
      padding: 5px;
    }

    flowboxchild:hover > .card,
    button:hover > .card,
    flowboxchild:active > .card,
    flowboxchild:selected > .card,
    button:active > .card,
    button:selected > .card,
    button:focus > .card {
      border: solid 1px @accent;
    }

    .image {
      border-radius: 5px;
    }

    .region-button {
      padding: 0.5rem 1rem;
      border-radius: 5px;
      background-color: @accent;
      color: @on_accent;
      transition: all 0.2s ease;
    }

    .region-button > label {
      color: @on_accent;
    }

    .region-button:not(:disabled):hover,
    .region-button:not(:disabled):focus {
      background-color: @accent_hover;
      color: @on_accent;
    }

    .region-button:disabled {
      background-color: @muted;
      color: @background;
    }
  '';

  pickerConfig = pkgs.writeText "hyprland-preview-share-picker.yaml" ''
    stylesheets: ["${pickerStylesheet}"]
    default_page: outputs

    image:
      resize_size: 500

    windows:
      max_per_row: 999
      clicks: 1

    outputs:
      clicks: 1

    region:
      command: ${pkgs.slurp}/bin/slurp -f '%o@%X,%Y,%W,%H'

    hide_token_restore: true
  '';
in
{
  home.packages = [ pkgs.hyprland-preview-share-picker ];

  xdg.configFile = {
    # Captures silently grant a restore token so clients can re-capture the
    # same source without prompting again. The picker's restore checkbox is
    # hidden to match.
    "hypr/xdph.conf".text = ''
      screencopy {
          allow_token_by_default = true
          custom_picker_binary = hyprland-preview-share-picker
      }
    '';

    "hyprland-preview-share-picker/config.yaml".source = pickerConfig;
  };

  home.activation.restartHyprlandPortal = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    conf="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/xdph.conf"
    applied="''${XDG_STATE_HOME:-$HOME/.local/state}/hypr/xdph.conf.applied"

    if ! ${pkgs.diffutils}/bin/cmp -s "$conf" "$applied"; then
      if ${pkgs.systemd}/bin/systemctl --user is-active --quiet xdg-desktop-portal-hyprland; then
        ${pkgs.systemd}/bin/systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal
      fi
      ${pkgs.coreutils}/bin/install -Dm644 "$conf" "$applied"
    fi
  '';
}
