let
  glyph = builtins.fromJSON;

  theme = import ./theme.nix;

  folderIcon = glyph ''"\ue5ff"'';
  folderOpenIcon = glyph ''"\ue5fe"'';
  nixIcon = glyph ''"\uf313"'';
in
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    theme = {
      mgr = {
        cwd = {
          fg = "#${theme.palette.accent}";
          bold = true;
        };
        border_style.fg = "#${theme.palette.separator}";
      };

      indicator = {
        parent = {
          bg = "#${theme.palette.surfaceLight}";
          bold = true;
        };
        current = {
          bg = "#${theme.palette.surfaceLight}";
          bold = true;
        };
        preview = {
          bg = "#${theme.palette.surfaceLight}";
          bold = true;
        };
      };

      tabs = {
        active = {
          fg = "#${theme.palette.foreground}";
          bold = true;
        };
        inactive = {
          fg = "#${theme.palette.accent}";
        };
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };

      mode = {
        normal_main = {
          bg = "#${theme.palette.accent}";
          fg = "#${theme.palette.background}";
          bold = true;
        };
        normal_alt = {
          bg = "#${theme.palette.surfaceLight}";
          fg = "#${theme.palette.accent}";
        };
        select_main = {
          bg = "#${theme.palette.surfaceLight}";
          fg = "#${theme.palette.accent}";
          bold = true;
        };
        unset_main = {
          bg = "#${theme.palette.surfaceLight}";
          fg = "#${theme.palette.accent}";
          bold = true;
        };
      };

      icon = {
        dirs = [ ];

        prepend_exts = [
          {
            name = "nix";
            text = nixIcon;
            fg = "#${theme.palette.accent}";
          }
        ];

        prepend_conds = [
          {
            "if" = "dir & hovered";
            text = folderOpenIcon;
            fg = "#${theme.palette.accent}";
          }
          {
            "if" = "dir";
            text = folderIcon;
            fg = "#${theme.palette.accent}";
          }
        ];
      };
    };
  };
}
