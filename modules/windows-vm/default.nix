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
    docker.enable = true;

    oci-containers = {
      backend = "docker";

      containers.windows-vm = {
        image = "dockurr/windows";
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

  services.onepassword-secrets = {
    enable = true;

    secrets.windowsVmPassword = {
      reference = "op://Personal/windows-vm/password";
      owner = username;
    };
  };

  systemd = {
    services.docker-windows-vm = {
      after = [ "opnix-secrets.service" ];
      wants = [ "opnix-secrets.service" ];

      preStart = ''
        umask 077
        printf 'PASSWORD=%s\n' "$(cat ${passwordFile})" > ${environmentFile}
      '';

      serviceConfig = {
        RuntimeDirectory = "windows-vm";
        TimeoutStopSec = lib.mkForce 150;
      };
    };

    tmpfiles.rules = [
      "d ${storageDirectory} 0700 root root -"
      "d ${shareDirectory} 0755 ${username} users -"
    ];
  };

  environment.systemPackages = [
    (pkgs.callPackage ./command.nix { inherit passwordFile username; })
  ];
}
