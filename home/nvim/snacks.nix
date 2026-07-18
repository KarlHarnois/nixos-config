{ pkgs, ... }:

let
  pickerKeymap = key: picker: desc: {
    mode = "n";
    inherit key;
    action.__raw = "function() Snacks.picker.${picker}() end";
    options.desc = desc;
  };
in
{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;

      settings = {
        statuscolumn.enabled = true;
        picker.enabled = true;
      };
    };

    extraPackages = [
      pkgs.ripgrep
      pkgs.fd
    ];

    keymaps = [
      (pickerKeymap "<leader><leader>" "files" "Find files")
      (pickerKeymap "<leader>/" "grep" "Grep files")
      (pickerKeymap "<leader>fb" "buffers" "Find buffers")
      (pickerKeymap "<leader>sh" "help" "Help pages")
      (pickerKeymap "<leader>fr" "recent" "Recent files")
    ];
  };
}
