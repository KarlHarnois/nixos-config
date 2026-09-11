{ osConfig, ... }:

let
  ollamaApiKeyFile = osConfig.services.onepassword-secrets.secretPaths.ollamaApiKey;
in
{
  programs.opencode = {
    enable = true;

    settings = {
      autoupdate = false;

      provider."ollama-cloud".options.apiKey = "{file:${ollamaApiKeyFile}}";

      permission = {
        bash = {
          "*" = "allow";
          env = "deny";
          "printenv *" = "deny";
          "gh auth token*" = "deny";
          "op read*" = "deny";
          "op inject*" = "deny";
          "op item *" = "deny";
          "op document get*" = "deny";
          "direnv export*" = "deny";
          "rm -rf *" = "deny";
        };
        read = {
          "*" = "allow";
          "/run/user/**" = "deny";
        };
      };
    };

    tui.theme = "system";
  };

  programs.bash.shellAliases = {
    oc = "opencode --auto";
    ocr = "opencode run --auto";
  };
}
