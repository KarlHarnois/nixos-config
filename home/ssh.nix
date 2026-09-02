{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."github.com".IdentityAgent = "~/.1password/agent.sock";
  };

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Workstation"
  '';
}
