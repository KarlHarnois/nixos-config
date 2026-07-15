{ ... }:

let
  glyph = builtins.fromJSON;

  diagnostics = {
    __unkeyed-1 = "diagnostics";
    symbols = {
      error = glyph ''"\uf057 "'';
      warn = glyph ''"\uf071 "'';
      info = glyph ''"\uf05a "'';
      hint = glyph ''"\uf0eb "'';
    };
  };

  fileTypeIcon = {
    __unkeyed-1 = "filetype";
    icon_only = true;
    separator = "";
    padding = { left = 1; right = 0; };
  };

  relativeFilePath = {
    __unkeyed-1 = "filename";
    path = 1;
    padding = { left = 0; right = 1; };
  };

  gitDiffFromGitsigns = {
    __unkeyed-1 = "diff";
    symbols = {
      added = glyph ''"\uf0fe "'';
      modified = glyph ''"\uf14b "'';
      removed = glyph ''"\uf146 "'';
    };
    source.__raw = ''
      function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end
    '';
  };

  progress = {
    __unkeyed-1 = "progress";
    separator = " ";
    padding = { left = 1; right = 0; };
  };

  location = {
    __unkeyed-1 = "location";
    padding = { left = 0; right = 1; };
  };

  clock.__raw = ''function() return "${glyph ''"\uf43a "''}" .. os.date("%R") end'';
in
{
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        disabled_filetypes.statusline = [ "snacks_dashboard" ];
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" ];
        lualine_c = [ diagnostics fileTypeIcon relativeFilePath ];
        lualine_x = [ gitDiffFromGitsigns ];
        lualine_y = [ progress location ];
        lualine_z = [ clock ];
      };

      extensions = [ "neo-tree" ];
    };
  };
}
