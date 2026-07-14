{ ... }:

let
  glyph = builtins.fromJSON;

  bar = "▎";
  caret = glyph ''"\uf0da"'';

  hunkSigns = {
    add.text = bar;
    change.text = bar;
    delete.text = caret;
    topdelete.text = caret;
    changedelete.text = bar;
  };
in
{
  programs.nixvim = {
    opts.signcolumn = "yes";

    plugins = {
      gitsigns = {
        enable = true;

        settings = {
          signs = hunkSigns // { untracked.text = bar; };
          signs_staged = hunkSigns;
        };
      };

      snacks = {
        enable = true;
        settings.statuscolumn.enabled = true;
      };
    };
  };
}
