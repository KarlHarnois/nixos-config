{
  programs.waybar.settings.mainBar.battery = {
    format = "{capacity}% {icon}";
    format-full = "󰂅";

    format-icons = {
      charging = [
        "󰢜"
        "󰂆"
        "󰂇"
        "󰂈"
        "󰢝"
        "󰂉"
        "󰢞"
        "󰂊"
        "󰂋"
        "󰂅"
      ];
      default = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };

    interval = 5;
    tooltip = false;
  };
}
