{
  config,
  lib,
  pkgs,
  ...
}:

let
  todoRoot = "${config.xdg.userDirs.documents}/Todo";
  neovim = lib.getExe config.programs.nixvim.build.package;
  hideChrome = "setlocal nonumber norelativenumber noswapfile signcolumn=no statuscolumn=";

  todo = pkgs.writeShellApplication {
    name = "todo";

    text = ''
      case "''${1:-}" in
        work)
          cd "${todoRoot}/Work"
          exec ${neovim} main.todo.md -c '${hideChrome}'
          ;;
        personal)
          cd "${todoRoot}/Personal"
          exec ${neovim} .
          ;;
        *)
          echo "usage: todo work|personal" >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  home.packages = [ todo ];
}
