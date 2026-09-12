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

      reason=""
      bodyFile=$(${lib.getExe' pkgs.coreutils "mktemp"})
      trap "rm -f $bodyFile" EXIT

      formatFailure() {
        ${lib.getExe pkgs.jq} --null-input --compact-output --arg label "$label" --arg reason "$1" '
          {
            text: "\($label) ?",
            tooltip: "Claude usage unavailable\n\($reason)"
          }
        '
      }

      readAccessToken() {
        ${lib.getExe pkgs.jq} -r '.claudeAiOauth.accessToken // empty' "$credentialsFile" 2>/dev/null
      }

      tokenExpiry() {
        ${lib.getExe pkgs.jq} -r '.claudeAiOauth.expiresAt // empty' "$credentialsFile" 2>/dev/null
      }

      isExpired() {
        local expiresAt=$1
        [ -n "$expiresAt" ] || return 1
        [ "$(( $(${lib.getExe' pkgs.coreutils "date"} +%s) * 1000 ))" -ge "$expiresAt" ]
      }

      fetchUsage() {
        local accessToken httpCode
        accessToken=$(readAccessToken) || {
          reason="credentials unreadable"
          return 1
        }
        [ -n "$accessToken" ] || {
          reason="not signed in"
          return 1
        }
        if isExpired "$(tokenExpiry)"; then
          reason="session expired, run Claude to refresh"
          return 1
        fi

        httpCode=$(printf 'Authorization: Bearer %s\n' "$accessToken" \
          | ${lib.getExe pkgs.curl} \
            --silent --show-error \
            --output "$bodyFile" \
            --write-out '%{http_code}' \
            --connect-timeout 5 \
            --max-time 10 \
            --header @- \
            https://api.anthropic.com/api/oauth/usage) || {
              reason="network error"
              return 1
            }

        case "$httpCode" in
          200) return 0 ;;
          401)
            reason="token rejected, run Claude to refresh"
            return 1
            ;;
          429)
            reason="rate limited"
            return 1
            ;;
          *)
            reason="HTTP $httpCode"
            return 1
            ;;
        esac
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

      if ! fetchUsage; then
        formatFailure "$reason"
        exit 0
      fi

      formatUsage < "$bodyFile" 2>/dev/null || formatFailure "unexpected response"
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
