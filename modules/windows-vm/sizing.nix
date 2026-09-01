{ lib, ... }:

{
  options.virtualisation.windows-vm = {
    memory = lib.mkOption { type = lib.types.str; };
    cores = lib.mkOption { type = lib.types.ints.positive; };
    diskSize = lib.mkOption { type = lib.types.str; };
  };
}
