{ pkgs, lib, config, ... }:
let
  inherit (lib)
    concatMapAttrs
    mkOption
  ;

  fileType = import ./lib/file-type.nix { inherit pkgs lib; };
  cfg = config.project.file;
in
{
  options = {
    project.file = mkOption {
      description = "Attribute set of files to copy into the project directory.";
      default = { };
      type = fileType "project.file";
    };
  };

  config = {
    perSystem = { stdenv }: {
      packages = let
        files = concatMapAttrs
          (filename: file:
            null
          )
          cfg
        ;
      in {
        "flake-manager/files" = stdenv.mkDerivation {
        };
      };
    };
  };
}
