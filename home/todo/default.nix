{
  config,
  lib,
  pkgs,
  ...
}:

let
  todoRoot = "${config.xdg.userDirs.documents}/Todo";
  neovim = lib.getExe config.programs.nixvim.build.package;
  hideChrome = "autocmd BufReadPre *.todo.md setlocal nonumber norelativenumber noswapfile signcolumn=no statuscolumn=";

  todo = pkgs.writeShellApplication {
    name = "todo";

    text = ''
      cd "${todoRoot}"

      case "''${1:-}" in
        work)
          exec ${neovim} --cmd '${hideChrome}' Work/main.todo.md
          ;;
        personal)
          exec ${neovim} --cmd '${hideChrome}' Personal/main.todo.md
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
