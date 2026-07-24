{ theme, ... }:

let
  glyph = builtins.fromJSON;

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
          fg = theme.palette.accent.hex;
          bold = true;
        };
        border_style.fg = theme.palette.separator.hex;
      };

      indicator = {
        parent = {
          bg = theme.palette.surfaceLight.hex;
          bold = true;
        };
        current = {
          bg = theme.palette.surfaceLight.hex;
          bold = true;
        };
        preview = {
          bg = theme.palette.surfaceLight.hex;
          bold = true;
        };
      };

      tabs = {
        active = {
          fg = theme.palette.foreground.hex;
          bold = true;
        };
        inactive = {
          fg = theme.palette.accent.hex;
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
          bg = theme.palette.accent.hex;
          fg = theme.palette.background.hex;
          bold = true;
        };
        normal_alt = {
          bg = theme.palette.surfaceLight.hex;
          fg = theme.palette.accent.hex;
        };
        select_main = {
          bg = theme.palette.surfaceLight.hex;
          fg = theme.palette.accent.hex;
          bold = true;
        };
        unset_main = {
          bg = theme.palette.surfaceLight.hex;
          fg = theme.palette.accent.hex;
          bold = true;
        };
      };

      icon = {
        dirs = [ ];

        prepend_exts = [
          {
            name = "nix";
            text = nixIcon;
            fg = theme.palette.accent.hex;
          }
        ];

        prepend_conds = [
          {
            "if" = "dir & hovered";
            text = folderOpenIcon;
            fg = theme.palette.accent.hex;
          }
          {
            "if" = "dir";
            text = folderIcon;
            fg = theme.palette.accent.hex;
          }
        ];
      };
    };
  };
}
