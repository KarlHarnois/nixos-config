let
  glyph = builtins.fromJSON;
in
{
  programs.nixvim = {
    plugins = {
      neo-tree = {
        enable = true;

        settings = {
          log_to_file = false;

          filesystem = {
            bind_to_cwd = false;
            follow_current_file.enabled = true;
            use_libuv_file_watcher = true;
          };

          window.mappings = {
            l = "open";
            h = "close_node";
            "<space>" = "none";
          };

          default_component_configs = {
            indent = {
              with_expanders = true;
              expander_collapsed = glyph ''"\uf460"'';
              expander_expanded = glyph ''"\uf47c"'';
              expander_highlight = "NeoTreeExpander";
            };

            git_status.symbols = {
              unstaged = glyph ''"\udb80\udd31"'';
              staged = glyph ''"\udb83\udc52"'';
            };
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>fe";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file tree";
      }
    ];
  };
}
