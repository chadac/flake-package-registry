{ inputs, lib, config, ... }: let
  inherit (lib)
    concatMap
    concatMapAttrs
    listToAttrs
    mapAttrs
    mapAttrs'
    mkOption
    types
  ;

  pyVersionNames = map (v: "python${v}") ["38" "39" "310" "311" "312" "313"];

  mkPerPythonOverlay = registry: final: prev: let
    pythonVersions = listToAttrs
      (map (name: { inherit name; value = final.${name}; }) pyVersionNames);
  in concatMapAttrs
    (pyVer: finalPython: let
      packageOverrides = self: super: mapAttrs
        (_: pybuilder:
          pybuilder {
            pkgs = final // { python3 = finalPython; pythonPackages = self; };
            python3 = finalPython;
            python3Packages = self;
          })
        registry;
      pyNew = finalPython.override {
        inherit packageOverrides;
        self = pyNew;
      };
    in {
      "${pyVer}" = pyNew;
    })
    pythonVersions
  ;

  pythonPackageType = types.functionTo types.package;
in {
  options = {
    flake.registry.python = mkOption {
      type = types.lazyAttrsOf pythonPackageType;
      description = "registry containing builders for Python packages.";
      example = ''
        flake.registry.python.my-package = { pkgs, python3, python3Packages, ... }:
          python3Packages.buildPythonPackage {
            <...>
          };
      '';
      default = { };
    };
  };

  config = {
    # export an overlay that flakes can use for their Python packages
    flake.overlays.pythonRegistry = mkPerPythonOverlay config.registry.python;

    flake-manager.registry.python = concatMapAttrs
      (name: input:
        if name == "self" then { }
        else input.registry.python or { })
      inputs
    ;

    flake-manager.overlays.python-registry = mkPerPythonOverlay config.flake-manager.registry.python;
  };
}
