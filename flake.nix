{
  description = "Modular development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  # flake-compat is needed for shell.nix
  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      ca-bundle-path = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      fhs = pkgs.buildFHSEnv {
        name = "fhs-shell";
        targetPkgs = pkgs: with pkgs; [ bash perl curl cacert python3 pixi zlib libxml2_13 ];
        profile = ''
          export SSL_CERT_FILE=${ca-bundle-path}
          export NIX_SSL_CERT_FILE=SSL_CERT_FILE;
        '';
      };
    in {
      devShells.default = fhs.env;
    });
}
