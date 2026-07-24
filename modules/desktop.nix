{
  pkgs,
  theme,
  username,
  ...
}:

{
  programs = {
    hyprland.enable = true;

    chromium = {
      enable = true;
      extraOpts = {
        BrowserColorScheme = "dark";
        BrowserThemeColor = theme.palette.background.hex;
      };
    };

    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };
  };

  security.rtkit.enable = true;

  security.pam.services.hyprlock = { };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = username;
      };
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --cmd start-hyprland";
    };
  };
}
