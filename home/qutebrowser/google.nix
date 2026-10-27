let
  calendar = "https://calendar.google.com";
  gmail = "https://mail.google.com";
  calendarPermissionScript = "calendar-notification-permission.user.js";
in
{
  programs.qutebrowser.perDomainSettings = {
    ${calendar}.content = {
      notifications.enabled = true;
      register_protocol_handler = true;
    };

    ${gmail}.content.register_protocol_handler = true;
  };

  xdg.configFile."qutebrowser/greasemonkey/${calendarPermissionScript}".source =
    ./${calendarPermissionScript};
}
