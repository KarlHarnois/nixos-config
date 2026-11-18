{ osConfig, pkgs, ... }:

let
  secretPaths = osConfig.services.onepassword-secrets.secretPaths;

  knaveMail = pkgs.writeShellApplication {
    name = "knave-mail";
    text = ''
      KNAVE_MAIL_CLIENT_ID=$(< ${secretPaths.knaveMailClientId})
      KNAVE_MAIL_CLIENT_SECRET=$(< ${secretPaths.knaveMailClientSecret})
      export KNAVE_MAIL_CLIENT_ID KNAVE_MAIL_CLIENT_SECRET
      exec "$HOME/.local/bin/knave-mail" "$@"
    '';
  };
in
{
  home.packages = [ knaveMail ];

  xdg.configFile."knave-mail/keymap.knv" = {
    force = true;
    text = ''
      (keymap (insert "jj" "<Esc>") (normal "<CR>" "o<Esc>"))
    '';
  };
}
