{ config, lib, ... }:

let
  cfg = config.programs.ringleader;

  desktopMemoryProtection = {
    overrideStrategy = "asDropin";
    sliceConfig.MemoryLow = cfg.desktopMemoryLow;
  };
in
{
  options.programs.ringleader = {
    memoryHigh = lib.mkOption {
      type = lib.types.str;
      description = "Memory throttling threshold for ringleader's agents and their builds. Size it per host to leave room for the desktop.";
    };

    desktopMemoryLow = lib.mkOption {
      type = lib.types.str;
      description = "Memory the desktop apps keep in RAM while ringleader competes for it. Size it per host to cover the browser's working set.";
    };
  };

  config.systemd = {
    slices = {
      user = desktopMemoryProtection;
      "user-" = desktopMemoryProtection;
    };

    services."user@" = {
      overrideStrategy = "asDropin";
      serviceConfig.MemoryLow = cfg.desktopMemoryLow;
    };

    user.slices = {
      app = desktopMemoryProtection;

      ringleader = {
        description = "Ringleader agents and their builds, capped to leave room for the desktop";
        sliceConfig = {
          MemoryHigh = cfg.memoryHigh;
          CPUWeight = "idle";
        };
      };
    };
  };
}
