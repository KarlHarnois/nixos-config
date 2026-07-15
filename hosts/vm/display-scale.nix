{ lib, ... }:

# The host passes its monitor resolution and scale as hypr_res and hypr_scale
# on the kernel cmdline (see the run-vm target in the Makefile). The mode is
# pinned explicitly because QEMU's window-size hints otherwise shrink the
# preferred mode to the window's logical size, which undoes the scaling.
let
  inherit (lib.generators) mkLuaInline;

  hostDisplay = {
    _var = mkLuaInline ''
      (function()
        local file = io.open("/proc/cmdline", "r")
        if not file then return {} end
        local cmdline = file:read("*a")
        file:close()
        return {
          mode = cmdline:match("hypr_res=([%dx]+)"),
          scale = tonumber(cmdline:match("hypr_scale=([%d.]+)")),
        }
      end)()'';
  };
in
{
  home-manager.users.karl.wayland.windowManager.hyprland.settings = {
    inherit hostDisplay;

    monitor = {
      mode = lib.mkForce (mkLuaInline ''hostDisplay.mode or "preferred"'');
      scale = lib.mkForce (mkLuaInline "hostDisplay.scale or 1");
    };
  };
}
