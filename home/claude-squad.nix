{ lib, pkgs, ... }:

let
  claudeSquad = pkgs.buildGoModule (finalAttrs: {
    pname = "claude-squad";
    version = "1.0.20";

    src = pkgs.fetchFromGitHub {
      owner = "smtg-ai";
      repo = "claude-squad";
      tag = "v${finalAttrs.version}";
      hash = "sha256-VyZ6nU84pL4RPXDZDVGCcOh8FwId1XokImdI/i7uw7Y=";
    };

    vendorHash = "sha256-0EFCao5l9BNX6zdHVziV9ZwJX9v+BNu+e3tcFtYrDJ4=";

    subPackages = [ "." ];
    ldflags = [
      "-s"
      "-w"
    ];
    doCheck = false;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postInstall = ''
      wrapProgram $out/bin/claude-squad --prefix PATH : ${lib.makeBinPath [ pkgs.tmux pkgs.gh ]}
      ln -s $out/bin/claude-squad $out/bin/cs
    '';
  });
in
{
  home.packages = [ claudeSquad ];
}
