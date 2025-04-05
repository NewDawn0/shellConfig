{ pkgs }:
let
  pandoc = { author }:
    pkgs.symlinkJoin {
      name = "pandoc-cfg";
      paths = [ pkgs.pandoc ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      text = (pkgs.formats.json { }).generate "pandoc.json" {
        metadata.author = author;
      };
      postBuild = ''
        wrapProgram $out/bin/pandoc \
          --add-flags "--defaults $text"
      '';
    };
in pkgs.lib.makeOverridable pandoc { author = "NewDawn0"; }
