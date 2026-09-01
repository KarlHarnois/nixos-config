{
  config,
  lib,
  username,
  ...
}:

let
  passwordFile = config.services.onepassword-secrets.secretPaths.windowsVmPassword;
  sizing = config.virtualisation.windows-vm;
  environmentFile = "/run/windows-vm/environment";
  shareDirectory = "/home/${username}/Windows";
  inherit (import ./paths.nix) storageDirectory;
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
          RAM_SIZE = sizing.memory;
          CPU_CORES = toString sizing.cores;
          DISK_SIZE = sizing.diskSize;
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

  systemd = {
    services.docker-windows-vm = {
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
}
