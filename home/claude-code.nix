{ pkgs, unstablePackages, ... }:

let
  workConfigDir = "$HOME/.claude-work";
  workTree = "$HOME/Projects/Work";

  claudeWithPerDirectoryAccount = pkgs.writeShellScriptBin "claude" ''
    repoLocation="$(${pkgs.git}/bin/git rev-parse --path-format=absolute --git-common-dir 2>/dev/null || echo "$PWD")"
    case "$repoLocation/" in
      "${workTree}/"*) export CLAUDE_CONFIG_DIR="${workConfigDir}" ;;
    esac
    exec ${unstablePackages.claude-code}/bin/claude "$@"
  '';
in
{
  home.packages = [ claudeWithPerDirectoryAccount ];
}
