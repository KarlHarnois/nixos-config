{
  lib,
  writeShellApplication,
  symlinkJoin,
  coreutils,
  gawk,
  gnugrep,
  iproute2,
  procps,
}:

let
  script = name: builtins.readFile (./scripts + "/${name}.sh");

  command =
    name: sourced:
    writeShellApplication {
      inherit name;

      runtimeInputs = [
        coreutils
        gawk
        gnugrep
        iproute2
        procps
      ];

      text = lib.concatMapStrings script (sourced ++ [ name ]);
    };
in
symlinkJoin {
  name = "l2tp-commands";

  paths = [
    (command "vpn-up" [
      "settings"
      "session"
    ])
    (command "vpn-down" [
      "settings"
      "session"
    ])
    (command "vpn-check" [ "settings" ])
  ];
}
