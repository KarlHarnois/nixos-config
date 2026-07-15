{ ... }:

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
        cwd = { fg = "#${theme.accent}"; bold = true; };
        hovered = { bg = "#${theme.surfaceLight}"; };
        preview_hovered = { bg = "#${theme.surface}"; };
        border_style.fg = "#${theme.surfaceLight}";
      };

      tabs = {
        active = { fg = "#${theme.foreground}"; bold = true; };
        inactive = { fg = "#${theme.accent}"; };
        sep_inner = { open = ""; close = ""; };
        sep_outer = { open = ""; close = ""; };
      };

      mode = {
        normal_main = { bg = "#${theme.accent}"; fg = "#${theme.background}"; bold = true; };
        normal_alt = { bg = "#${theme.surfaceLight}"; fg = "#${theme.accent}"; };
        select_main = { bg = "#${theme.surfaceLight}"; fg = "#${theme.accent}"; bold = true; };
        unset_main = { bg = "#${theme.surfaceLight}"; fg = "#${theme.accent}"; bold = true; };
      };

      icon.prepend_exts = [
        { name = "nix"; text = nixIcon; fg = "#${theme.accent}"; }
      ];

      icon.prepend_conds = [
        { "if" = "dir & hovered"; text = folderOpenIcon; fg = "#${theme.accent}"; }
        { "if" = "dir"; text = folderIcon; fg = "#${theme.accent}"; }
      ];
    };
  };
}
