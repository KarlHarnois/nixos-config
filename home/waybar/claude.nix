{
  config,
  lib,
  pkgs,
  ...
}:

let
  homeDir = config.home.homeDirectory;

  mkClaudeUsage =
    {
      label,
      name,
      configDir,
    }:
    pkgs.writeShellScript "claude-usage-${label}" ''
      set -euo pipefail

      readonly label=${lib.escapeShellArg label}
      readonly name=${lib.escapeShellArg name}
      readonly credentialsFile=${lib.escapeShellArg "${configDir}/.credentials.json"}

      printUnavailable() {
        ${lib.getExe pkgs.jq} --null-input --compact-output --arg label "$label" '
          {
            text: "\($label) ?",
            tooltip: "Claude usage unavailable"
          }
        '
      }

      fetchUsage() {
        local accessToken
        accessToken=$(${lib.getExe pkgs.jq} -r '.claudeAiOauth.accessToken // empty' "$credentialsFile" 2>/dev/null) \
          || return 1
        [ -n "$accessToken" ] || return 1

        ${lib.getExe pkgs.curl} \
          --silent --show-error --fail \
          --connect-timeout 5 \
          --max-time 10 \
          --header "Authorization: Bearer $accessToken" \
          https://api.anthropic.com/api/oauth/usage
      }

      formatUsage() {
        ${lib.getExe pkgs.jq} -e --compact-output --arg label "$label" --arg name "$name" '
          .five_hour
          | select(. != null)
          | {
              text: "\($label) \(.utilization | floor)%",
              tooltip:
                "Claude (\($name))\n"
                + "\(.utilization | floor)% of session limit used\n"
                + "Resets \(.resets_at // "unknown")"
            }
        '
      }

      response=$(fetchUsage) || {
        printUnavailable
        exit 0
      }

      printf '%s' "$response" | formatUsage 2>/dev/null || printUnavailable
    '';
in
{
  programs.waybar = {
    settings.mainBar."custom/claude" = {
      exec = mkClaudeUsage {
        label = "CLD";
        name = "personal";
        configDir = "${homeDir}/.claude";
      };
      return-type = "json";
      interval = 300;
      tooltip = true;
      escape = true;
    };

    settings.mainBar."custom/claude-work" = {
      exec = mkClaudeUsage {
        label = "CLD-W";
        name = "work";
        configDir = "${homeDir}/.claude-work";
      };
      return-type = "json";
      interval = 300;
      tooltip = true;
      escape = true;
    };
  };
}
