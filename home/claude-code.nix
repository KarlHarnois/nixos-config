{
  lib,
  pkgs,
  skills,
  ...
}:

let
  workConfigDir = "$HOME/.claude-work";
  workTree = "$HOME/Projects/Work";

  claudeWithPerDirectoryAccount = pkgs.writeShellScriptBin "claude" ''
    case "$PWD/" in
      "${workTree}/"*) export CLAUDE_CONFIG_DIR="${workConfigDir}" ;;
    esac
    exec ${pkgs.claude-code}/bin/claude "$@"
  '';

  configDirs = [
    ".claude"
    ".claude-work"
  ];

  entriesOf = dir: builtins.attrNames (builtins.readDir "${skills}/${dir}");

  linkEntry = configDir: dir: name: {
    name = "${configDir}/${dir}/${name}";
    value = {
      source = "${skills}/${dir}/${name}";
      force = true;
    };
  };

  linksFor = dir: lib.concatMap (configDir: map (linkEntry configDir dir) (entriesOf dir)) configDirs;
in
{
  home.packages = [ claudeWithPerDirectoryAccount ];

  home.file = lib.listToAttrs (linksFor "skills" ++ linksFor "agents");
}
