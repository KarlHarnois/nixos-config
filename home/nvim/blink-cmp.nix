{ ... }:

{
  programs.nixvim.plugins = {
    friendly-snippets.enable = true;

    blink-cmp = {
      enable = true;

      settings = {
        appearance.nerd_font_variant = "mono";

        completion = {
          accept.auto_brackets.enabled = true;
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
          };
        };

        sources.default = [ "lsp" "path" "snippets" "buffer" ];

        cmdline = {
          enabled = true;

          keymap = {
            preset = "cmdline";
            "<Right>" = false;
            "<Left>" = false;
          };

          completion = {
            list.selection.preselect = false;
            menu.auto_show.__raw = ''function() return vim.fn.getcmdtype() == ":" end'';
            ghost_text.enabled = true;
          };
        };

        keymap = {
          preset = "default";
          "<Tab>" = [ "select_and_accept" "fallback" ];
          "<C-j>" = [ "select_next" "fallback" ];
          "<C-k>" = [ "select_prev" "fallback" ];
        };
      };
    };
  };
}
