{ lib, username, ... }:

# The host passes its monitor resolution and scale as hypr_res and hypr_scale
# on the kernel cmdline (see the vm target in the Makefile). The mode is
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
        local res = cmdline:match("hypr_res=([%dx]+)")
        local hz = cmdline:match("hypr_hz=([%d.]+)")
        return {
          mode = res and (hz and res .. "@" .. hz or res),
          scale = tonumber(cmdline:match("hypr_scale=([%d.]+)")),
        }
      end)()'';
  };
in
{
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    inherit hostDisplay;

    monitor = {
      mode = lib.mkForce (mkLuaInline ''hostDisplay.mode or "preferred"'');
      scale = lib.mkForce (mkLuaInline "hostDisplay.scale or 1");
    };
  };
}
