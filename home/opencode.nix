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
  denySubstrings = texts: deny (map (text: "*${text}*") texts);
  denySubtrees = roots: deny (map (root: "${root}/**") roots);
  denyParentDirectories = paths: deny (map (path: "${dirOf path}/*") paths);

  commandSubstringDenies = denySubstrings (guardedDirectories ++ guardedFiles);
  fileNameSubstringDenies = denySubstrings (map baseNameOf guardedFiles);
  directorySubtreeDenies = denySubtrees guardedDirectories;
  parentDirectoryDenies = denyParentDirectories guardedFiles;
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
        // commandSubstringDenies;

        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.*" = "deny";
          "*.env.example" = "allow";
          "*.envrc" = "deny";
          "*.envrc.*" = "deny";
        }
        // directorySubtreeDenies
        // fileNameSubstringDenies;

        list = {
          "*" = "allow";
        }
        // directorySubtreeDenies
        // fileNameSubstringDenies;

        external_directory = directorySubtreeDenies // parentDirectoryDenies;
      };
    };

    tui.theme = "system";
  };

  programs.bash.shellAliases = {
    oc = "opencode --auto";
    ocr = "opencode run --auto";
    occ = "opencode --continue --auto";
  };
}
