# flake-registry

Provides an "equivalent" package registry for packages published by
Nix Flakes.

Suppose you have a Python library, `my-library`, that you store within
a Nix Flake on one of your packages and you would like to use in a
downstream package. Right now it's a bit difficult -- Python packages
are not derivations but instead specialized attribute sets used to
build Python environments. The same goes for most other
language-specific libraries.

What we'd like is for flakes to publish libraries as well as enable
them to override any default libraries provided by `nixpkgs`.

## Usage

### flake-manager

With [flake-manager](https://github.com/chadac/flake-manager), exports
and imports and handled fairly automatically.

#### Publishing libraries

Libraries are functions that map to language-specific packages. For
example:

    {
      inputs.flake-manager.url = "github:chadac/flake-manager";
      inputs.flake-registry.url = "github:chadac/flake-registry";

      outputs = { flake-manager, ... }@inputs = flake-manager.lib.mkFlake { inherit inputs; } {
        python.packages.my-library = {
          src = "<...>";
        };
      };
    }

#### Consuming libraries

Consuming libraries is automatic with `flake-manager`. For example:

    {
      inputs.flake-manager.url = "github:chadac/flake-manager";
      inputs.flake-registry.url = "github:chadac/flake-registry";
      inputs.my-library.url = "github:my/library";

      outputs = { flake-manager, ... }: flake-manager.lib.mkFlake { inherit inputs; } {
        poetry.apps.my-service = {
          src = "<...>";
        };
      };
    }

`flake-manager` will automatically build the Poetry application with
an overlay providing `my-library` from the Flake input. There is no
need to do any additional explicit configuration.

### flake-parts

It is also possible to manually publish/consume libraries with
[flake-parts](https://github.com/hercules-ci/flake-parts).

#### Publishing

    {
      inputs.flake-manager.url = "github:chadac/flake-manager";
      inputs.flake-registry.url = "github:chadac/flake-registry";

      outputs = { flake-manager, ... }@inputs = flake-manager.lib.mkFlake { inherit inputs; } {
        flake.registry.python.my-library = { pkgs, python, pythonPackages, ... }:
          pythonPackages.buildPythonPackages { ... };
      };
    }

#### Consuming

`flake-registry` publishes packages in two locations:

* `flake.overlays.<language>Registry` is a `nixpkgs` overlay that
  overrides each version of Python with the packages given in the
  input; use this when you can build your packages straight from
  `nixpkgs`.
* `flake.registry.<language>` is an attribute set of functions that
  build libraries, as provided above.

With
[flake-manager](https://github.com/chadac/flake-manager), registries
are automatic. They will be imported via overlays and any default
exports for your packages will already prefer Flake inputs over the
preset defaults.

Without flake-manager, you can still import any exported libraries
