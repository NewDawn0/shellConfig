{ pkgs }:
let
  defaultConfig = {
    author = "NewDawn0";
    language = "en";
    toc = true;
  };
in pkgs.lib.makeOverridable ({ config ? defaultConfig }:
  pkgs.symlinkJoin {
    name = "pandoc";
    paths = with pkgs; [ pandoc ];
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    text = (pkgs.formats.json { }).generate "pandoc.json" {
      metadata = { inherit (config) author language toc; };
    };
    postBuild = ''
      install -Dm644 $text $out/share/pandoc/pandoc.json
      wrapProgram $out/bin/pandoc \
        --add-flags "--defaults $out/share/pandoc/pandoc.json"
    '';

  }) { config = defaultConfig; }
