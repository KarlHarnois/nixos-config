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
        padding: 0 4px;
        margin-right: 7px;
      }
    '';
  };
}
