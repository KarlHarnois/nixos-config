{
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  apiKeyFile = osConfig.services.onepassword-secrets.secretPaths.ollamaApiKey;

  ollamaUsage = pkgs.writeShellScript "ollama-usage" ''
    set -euo pipefail

    readonly unavailable='{"text":"OLL ?","tooltip":"Ollama usage unavailable"}'
    readonly apiKeyFile=${lib.escapeShellArg apiKeyFile}
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
    settings.mainBar."custom/ollama" = {
      exec = ollamaUsage;
      return-type = "json";
      interval = 300;
      tooltip = true;
      escape = true;
    };

    style = ''
      #custom-ollama {
        min-width: 12px;
        margin-right: 7.5px;
      }
    '';
  };
}
