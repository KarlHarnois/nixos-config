{ config, lib, ... }:

{
  options.programs.ringleader.memoryHigh = lib.mkOption {
    type = lib.types.str;
    description = "Memory throttling threshold for ringleader's agents and their builds. Size it per host to leave room for the desktop.";
  };

  config.systemd.user.slices.ringleader = {
    description = "Ringleader agents and their builds, capped to leave room for the desktop";
    sliceConfig = {
      MemoryHigh = config.programs.ringleader.memoryHigh;
      CPUWeight = "idle";
    };
  };
}
