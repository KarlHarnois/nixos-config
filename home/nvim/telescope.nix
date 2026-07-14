{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader><leader>" = { action = "find_files"; options.desc = "Find files"; };
        "<leader>/" = { action = "live_grep"; options.desc = "Grep files"; };
        "<leader>fb" = { action = "buffers"; options.desc = "Find buffers"; };
        "<leader>sh" = { action = "help_tags"; options.desc = "Help pages"; };
        "<leader>fr" = { action = "oldfiles"; options.desc = "Recent files"; };
      };
    };

    extraPackages = [ pkgs.ripgrep pkgs.fd ];
  };
}
