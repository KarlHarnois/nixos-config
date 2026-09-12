{
  lib,
  pkgs,
  theme,
  osConfig,
  ...
}:

let
  pinnedWorkspaceCount = 5;
  pinnedWorkspaces = map toString (lib.range 1 pinnedWorkspaceCount);

  voxtypeStatusStream = pkgs.writeShellScript "voxtype-status-stream" ''
    trap 'kill 0' EXIT
    ${pkgs.voxtype-onnx}/bin/voxtype status --follow --extended --format json \
      | ${lib.getExe pkgs.jq} --unbuffered --compact-output '. + {alt: .class}'
  '';

  ollamaApiKeyFile = osConfig.services.onepassword-secrets.secretPaths.ollamaApiKey;

  ollamaUsage = pkgs.writeShellScript "ollama-usage" ''
    set -euo pipefail

    readonly unavailable='{"text":"OLL ?","tooltip":"Ollama usage unavailable"}'
    readonly apiKeyFile=${lib.escapeShellArg ollamaApiKeyFile}
    readonly keyWaitAttempts=12
    readonly keyWaitInterval=5

    waitForApiKey() {
      local attempt
      for ((attempt = 0; attempt < keyWaitAttempts; attempt++)); do
        [ -r "$apiKeyFile" ] && return 0
        sleep "$keyWaitInterval"
      done
      return 1
    }

    fetchUsage() {
      local apiKey
      apiKey=$(<"$apiKeyFile")

      printf 'Authorization: Bearer %s\n' "$apiKey" \
        | ${lib.getExe pkgs.curl} \
          --silent --show-error --fail \
          --connect-timeout 5 \
          --max-time 10 \
          --header @- \
          https://ollama.com/api/usage
    }

    formatUsage() {
      ${lib.getExe pkgs.jq} -e --compact-output '
        .limits.monthly
        | (.usage // 0) as $usage
        | (.models // []) as $models
        | {
            text: "OLL \(($usage * 1000 | floor) / 10)%",
            tooltip:
              "Ollama Cloud\n"
              + "\(($usage * 1000 | floor) / 10)% of monthly credits\n\n"
              + ([$models[] | "\(.name): \(.request_count)"] | join("\n"))
          }
      '
    }

    printUsage() {
      local response
      response=$(fetchUsage) || {
        printf '%s\n' "$unavailable"
        return
      }

      printf '%s' "$response" | formatUsage 2>/dev/null || printf '%s\n' "$unavailable"
    }

    waitForApiKey || {
      printf '%s\n' "$unavailable"
      exit 0
    }

    printUsage
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [
        "clock"
        "custom/voxtype"
      ];
      modules-right = [
        "custom/ollama"
        "battery"
      ];

      "hyprland/workspaces" = {
        format = "{icon}";

        format-icons = {
          "10" = "0";
          active = "󱓻";
        };

        persistent-workspaces = lib.genAttrs pinnedWorkspaces (_: [ ]);
      };

      clock = {
        format = "{:L%a %b %d %H:%M}";
        tooltip = false;
      };

      "custom/voxtype" = {
        exec = voxtypeStatusStream;
        return-type = "json";
        format = "{icon}";

        format-icons = {
          idle = "";
          recording = "󰍬";
          transcribing = "󰔟";
        };
      };

      "custom/ollama" = {
        exec = ollamaUsage;
        return-type = "json";
        interval = 300;
        tooltip = true;
        escape = true;
      };

      battery = {
        format = "{capacity}% {icon}";
        format-full = "󰂅";

        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        interval = 5;
        tooltip = false;
      };
    };

    style = ''
      @define-color accent ${theme.palette.accent.hex};
      @define-color surface ${theme.palette.surface.hex};

      * {
        background-color: @surface;
        color: @accent;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: '${theme.font}';
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #custom-voxtype {
        min-width: 12px;
        margin-left: 7.5px;
      }

      #custom-ollama {
        min-width: 12px;
        margin-right: 7.5px;
      }
    '';
  };
}
