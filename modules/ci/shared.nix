{ ... }:
let
  taskType = types.submodule ({ name, config, ... }: {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether this stage should be executed.
        '';
      };
    };
  });
in
{
  options = {
    ci.basic.task
  };
}
