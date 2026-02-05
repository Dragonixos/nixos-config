{
  description = "NixOS configuration with home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, nix-openclaw, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          # Integrate home-manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [ 
              plasma-manager.homeModules.plasma-manager
            ];
            home-manager.users.markw = import ./home.nix;
            home-manager.users.mark = import ./home-mark.nix;

            # Workarounds for nix-openclaw
            nixpkgs.overlays = [
              nix-openclaw.overlays.default
              (final: prev: {
                openclaw-gateway = prev.openclaw-gateway.overrideAttrs (oldAttrs: {
                  installPhase = ''
                    ${oldAttrs.installPhase}
                    mkdir -p $out/lib/openclaw/docs/reference/templates
                    cp -r $src/docs/reference/templates/* $out/lib/openclaw/docs/reference/templates/
                  '';
                });
              })
            ];
          }
        ];
      };
    };
}
