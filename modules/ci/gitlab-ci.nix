{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
  ;

  cfg = config.gitlab-ci;

  includeType = types.submodule ({ name, config, ... }: {
  });
  cacheType = types.submodule ({ name, config, ... }: {
  });
  coverageType = types.submodule ({ name, config, ... }: {
  });
  dastConfigurationType = types.submodule ({ name, config, ... }: {
  });
  idTokenType = types.submodule ({ name, config, ... }: {
  });
  imageType = types.submodule ({ name, config, ... }: {
  });
  inheritType = types.submodule ({ name, config, ... }: {
  });
  needsType = types.submodule ({ name, config, ... }: {
  });
  jobType = types.submodule ({ name, config, ... }: {
    after_script = mkOption { type = types.lines; };
    script = mkOption { type = types.lines; };
    before_script = mkOption { type = types.lines; };
    cache = mkOption { type = cacheType; };
    coverage = mkOption { type = coverageType; };
    dast_configuration = mkOption { type = dastConfigurationType; };
    dependencies = mkOption { type = types.listOf types.str; };
    environment = mkOption { type = types.str; };
    extends = mkOption { type = types.listOf types.str; };
    identity = mkOption { type = types.enum [ "google_cloud" ]; };
    id_tokens = mkOption { type = types.attrsOf idTokenType; };
    image = mkOption { type = imageType; };
    inherit_ = mkOption { type = inheritType; };
    interruptable = mkOption { type = types.bool; };
    needs = mkOption { type = types.listOf needsType; };
    parallel = mkOption { type = types.int; };
  });
in
{
  options = {
    gitlab-ci = {
      enable = mkEnableOption "whether or not to generate a .gitlab-ci.yml file at the root of the project.";
      file = mkOption {
        jobs = mkOption {
          type = types.attrsOf jobType;
          default = { };
          description = "gitlab job specification";
        };
      };
    };
  };
}
