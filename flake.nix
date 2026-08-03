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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
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
      nixos-hardware,
      disko,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      username = "karl";

      theme = import ./themes/contract.nix (import ./themes/darkthrone);

      desktop = {
        imports = [
          ./modules
          home-manager.nixosModules.home-manager
        ];

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
      };

      vmSystem = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixpkgs-unstable theme username; };
        modules = [
          desktop
          ./hosts/vm
        ];
      };

      vmRunner = vmSystem.config.system.build.vm;

      frameworkSystem = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixpkgs-unstable theme username; };
        modules = [
          desktop
          ./hosts/framework
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-intel-core-ultra-series1
        ];
      };
    in
    {
      nixosConfigurations.framework = frameworkSystem;

      packages.${system} = {
        vm = vmRunner;
        vmToplevel = vmSystem.config.virtualisation.vmVariant.system.build.toplevel;
        l2tp-commands = pkgs.callPackage ./modules/l2tp-client/commands.nix { };
        mtgo = pkgs.callPackage ./home/mtgo/command.nix { };
      };

      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        vm = vmRunner;

        framework = frameworkSystem.config.system.build.toplevel;

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
