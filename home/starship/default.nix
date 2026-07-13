{ lib, ... }:

{
  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    settings = lib.importTOML ./starship.toml;
  };
}
