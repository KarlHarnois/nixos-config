{
  description = "Karl's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      username = "karl";

      theme = import ./themes/contract.nix (import ./themes/darkthrone);

      vmSystem = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixpkgs-unstable theme username; };
        modules = [
          ./hosts/vm
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit theme; };
              sharedModules = [
                nixvim.homeModules.nixvim
                ({ pkgs, ... }: { programs.nixvim.nixpkgs.pkgs = pkgs; })
              ];
              users.${username} = ./home;
            };
          }
        ];
      };

      vmRunner = vmSystem.config.system.build.vm;
    in
    {
      packages.${system} = {
        vm = vmRunner;
        vmToplevel = vmSystem.config.virtualisation.vmVariant.system.build.toplevel;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        vm = vmRunner;

        formatting = pkgs.runCommand "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
          nixfmt --check $(find ${self} -name '*.nix')
          touch $out
        '';

        lint = pkgs.runCommand "check-lint" { nativeBuildInputs = [ pkgs.statix ]; } ''
          statix check ${self}
          touch $out
        '';

        dead-code = pkgs.runCommand "check-dead-code" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          deadnix --fail ${self}
          touch $out
        '';
      };
    };
}
