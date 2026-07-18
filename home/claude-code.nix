{ pkgs, ... }:

let
  workConfigDir = "$HOME/.claude-work";
  workTree = "$HOME/Projects/Work";

  claudeWithPerDirectoryAccount = pkgs.writeShellScriptBin "claude" ''
    case "$PWD/" in
      "${workTree}/"*) export CLAUDE_CONFIG_DIR="${workConfigDir}" ;;
    esac
    exec ${pkgs.claude-code}/bin/claude "$@"
  '';
in
{
  home.packages = [ claudeWithPerDirectoryAccount ];
}
