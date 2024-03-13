{
  description = "Manage pseudo package registries for various languages.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    flake.lib.flakeModule = import ./modules/all-modules.nix { inherit inputs; };
  };
}
