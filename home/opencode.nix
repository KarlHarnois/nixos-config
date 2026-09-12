{
  config,
  lib,
  osConfig,
  ...
}:

let
  secretsDir = osConfig.services.onepassword-secrets.outputDir;
  ollamaApiKeyFile = osConfig.services.onepassword-secrets.secretPaths.ollamaApiKey;
  opnixTokenFile = osConfig.services.onepassword-secrets.tokenFile;
  opencodeAuthFile = "${config.home.homeDirectory}/.local/share/opencode/auth.json";

  guardedDirectories = [
    secretsDir
    "/run/user"
  ];

  guardedFiles = [
    opencodeAuthFile
    opnixTokenFile
  ];

  deny = paths: lib.genAttrs paths (_: "deny");
  denyTrees = roots: deny (map (root: "${root}/**") roots);
  denyPathMentions = paths: deny (map (path: "*${path}*") paths);

  guardedPaths = deny guardedFiles // denyTrees guardedDirectories;
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
        }
        // denyPathMentions guardedDirectories
        // denyPathMentions guardedFiles;

        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.*" = "deny";
          "*.env.example" = "allow";
          "*.envrc" = "deny";
          "*.envrc.*" = "deny";
        }
        // guardedPaths;

        list = {
          "*" = "allow";
        }
        // guardedPaths;

        external_directory = guardedPaths;
      };
    };

    tui.theme = "system";
  };

  programs.bash.shellAliases = {
    oc = "opencode --auto";
    ocr = "opencode run --auto";
  };
}
