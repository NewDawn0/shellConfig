{ pkgs }:
let
  files = with builtins;
    map (pkgs.lib.removeSuffix ".nix")
    (filter (f: f != "default.nix") (attrNames (readDir ./.)));
  outPkgs = with builtins;
    listToAttrs (map (file: {
      name = file;
      value = import (./. + "/${file}.nix") { inherit pkgs; };
    }) files);
in outPkgs
