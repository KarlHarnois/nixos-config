{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-toolbox";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "mcp-toolbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NHx7gFcNYhsHX4vQ8Bl52PF/lLa8NuXxb390Z4Dk1PA=";
  };

  vendorHash = "sha256-12+ebXdWnmIetot6MhV0czJHRMpf3ZndS2ChaGstd7w=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/mcp-toolbox $out/bin/toolbox
  '';

  meta = {
    mainProgram = "toolbox";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.asl20;
  };
})
