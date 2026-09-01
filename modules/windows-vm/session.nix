{
  config,
  pkgs,
  username,
  ...
}:

let
  passwordFile = config.services.onepassword-secrets.secretPaths.windowsVmPassword;
  inherit (import ./paths.nix) storageDirectory;
in

{
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      var verbs = ["start", "stop", "restart"];
      if (
        action.id == "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") == "docker-windows-vm.service" &&
        verbs.indexOf(action.lookup("verb")) != -1 &&
        subject.user == "${username}"
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.systemPackages = [
    (pkgs.callPackage ./command.nix { inherit passwordFile storageDirectory username; })

    (pkgs.makeDesktopItem {
      name = "windows-vm";
      desktopName = "Windows";
      exec = "windows-vm";
      terminal = true;
      categories = [ "System" ];
    })
  ];
}
