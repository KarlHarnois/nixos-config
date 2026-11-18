{ username, ... }:

{
  services.onepassword-secrets = {
    enable = true;

    secrets.windowsVmPassword = {
      reference = "op://Workstation/Windows VM/password";
      owner = username;
    };

    secrets.ollamaApiKey = {
      reference = "op://Workstation/Ollama/credential";
      owner = username;
    };

    secrets.knaveMailClientId = {
      reference = "op://Workstation/knave-mail Google OAuth/client_id";
      owner = username;
    };

    secrets.knaveMailClientSecret = {
      reference = "op://Workstation/knave-mail Google OAuth/client_secret";
      owner = username;
    };
  };
}
