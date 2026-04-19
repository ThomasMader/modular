# If bazel fails try to delete the cache in /home/thomad/.cache/bazel first.
{
  description = "Modular development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = nixpkgs.lib.systems.flakeExposed;
    in {
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          fhs = pkgs.buildFHSEnv {
            name = "fhs-shell";
            targetPkgs = pkgs: with pkgs; [
              bash perl curl python3 pixi zlib coreutils libxml2_13
            ];
            runScript = "bash";
            profile = "";
          };
        in {
          default = fhs.env;
        }
      );
    };
}

