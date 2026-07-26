{ pkgs, ... }:

let
  stateDir = "/var/lib/l2tp";

  commands = pkgs.callPackage ./commands.nix { };

  daemonConf = pkgs.writeText "strongswan.conf" ''
    charon {
      plugins {
        stroke {
          secrets_file = ${stateDir}/ipsec.secrets
        }
      }
    }

    starter {
      config_file = ${stateDir}/ipsec.conf
    }
  '';
in
{
  boot.kernelModules = [ "l2tp_ppp" ];

  environment.systemPackages = [
    pkgs.strongswan
    commands
  ];

  systemd.tmpfiles.rules = [ "d ${stateDir} 0700 root root -" ];

  systemd.services = {
    strongswan = {
      description = "strongSwan IPsec daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = [
        pkgs.iproute2
        pkgs.iptables
        pkgs.kmod
        pkgs.util-linux
      ];
      environment.STRONGSWAN_CONF = daemonConf;
      unitConfig.ConditionPathExists = "${stateDir}/ipsec.conf";
      serviceConfig.ExecStart = "${pkgs.strongswan}/sbin/ipsec start --nofork";
    };

    xl2tpd = {
      description = "xl2tpd L2TP client";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "strongswan.service"
      ];
      unitConfig.ConditionPathExists = "${stateDir}/xl2tpd.conf";
      serviceConfig = {
        ExecStart = "${pkgs.xl2tpd}/bin/xl2tpd -D -c ${stateDir}/xl2tpd.conf -C /run/xl2tpd/l2tp-control";
        RuntimeDirectory = "xl2tpd";
      };
    };
  };
}
