{
  inputs = {
    jetbrains-updater.url = "gitlab:genericnerdyusername/jetbrains-updater";
  };
  outputs = { self, nixpkgs, ... }@attrs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.probook = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [ 
          ./configuration.nix
        ];
      };
    };
  }
