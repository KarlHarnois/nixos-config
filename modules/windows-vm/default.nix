{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  passwordFile = config.services.onepassword-secrets.secretPaths.windowsVmPassword;
  environmentFile = "/run/windows-vm/environment";
  storageDirectory = "/var/lib/windows-vm/storage";
  shareDirectory = "/home/${username}/Windows";
in

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };

    oci-containers = {
      backend = "docker";

      containers.windows-vm = {
        image = "dockurr/windows:6.05";
        autoStart = false;

        environment = {
          VERSION = "11";
          RAM_SIZE = "8G";
          CPU_CORES = "4";
          DISK_SIZE = "64G";
          USERNAME = username;
          PROTECT = "Y";
          TZ = config.time.timeZone;
          ARGUMENTS = "-rtc base=localtime,clock=host,driftfix=slew";
        };

        environmentFiles = [ environmentFile ];

        ports = [
          "127.0.0.1:8006:8006"
          "127.0.0.1:3389:3389/tcp"
          "127.0.0.1:3389:3389/udp"
        ];

        volumes = [
          "${storageDirectory}:/storage"
          "${shareDirectory}:/shared"
          "${./oem}:/oem:ro"
        ];

        devices = [
          "/dev/kvm"
          "/dev/net/tun"
        ];

        capabilities.NET_ADMIN = true;

        extraOptions = [ "--stop-timeout=120" ];
      };
    };
  };

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

  services.onepassword-secrets = {
    enable = true;

    secrets.windowsVmPassword = {
      reference = "op://Workstation/Windows VM/password";
      owner = username;
    };
  };

  systemd = {
    services.docker-windows-vm = {
      after = [ "opnix-secrets.service" ];
      wants = [ "opnix-secrets.service" ];

      preStart = ''
        umask 077
        password=$(cat ${passwordFile})
        printf 'PASSWORD=%s\n' "$password" > ${environmentFile}
      '';

      serviceConfig = {
        RuntimeDirectory = "windows-vm";
        TimeoutStopSec = lib.mkForce 150;
      };
    };

    tmpfiles.rules = [
      "d ${storageDirectory} 0750 root users -"
      "d ${shareDirectory} 0755 ${username} users -"
    ];
  };

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
