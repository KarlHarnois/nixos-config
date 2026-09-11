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
  };
}
