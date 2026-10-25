{
  programs.waybar = {
    settings.mainBar.battery = {
      format = "bat:{capacity}%";
      format-charging = "bat:{capacity}%+";
      interval = 5;
      tooltip = false;

      states = {
        warning = 20;
        critical = 10;
      };
    };

    style = ''
      #battery.warning {
        color: @accent;
      }

      #battery.critical {
        color: @alert;
      }
    '';
  };
}
