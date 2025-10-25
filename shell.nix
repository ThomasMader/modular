# To support non-flake-enabled nix instances.
{ system ? builtins.currentSystem }:
(builtins.getFlake (toString ./.)).devShells.${system}.default
