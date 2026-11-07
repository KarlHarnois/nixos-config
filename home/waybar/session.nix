{
  programs.waybar = {
    settings.mainBar."custom/session" = {
      format = "<span font='IosevkaTerm Nerd Font'></span>";
      tooltip = false;
    };

    style = ''
      #custom-session {
        background-color: @accent;
        color: @background;
        padding-left: 4px;
        padding-right: 12px;
        margin-right: 7px;
      }
    '';
  };
}
