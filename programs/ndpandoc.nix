{ pkgs }:
let
  defaultConfig = {
    author = "NewDawn0";
    language = "en";
    toc = true;
  };
in pkgs.lib.makeOverridable ({ config ? defaultConfig }:
  pkgs.symlinkJoin {
    name = "ndpandoc";
    paths = with pkgs; [ pandoc ];
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    text = (pkgs.formats.json { }).generate "pandoc.json" {
      metadata = { inherit (config) author language toc; };
    };
    postBuild = ''
      install -Dm644 $text $out/share/pandoc/pandoc.json
      mv $out/bin/pandoc $out/bin/ndpandoc
      wrapProgram $out/bin/ndpandoc \
        --add-flags "--defaults $out/share/pandoc/pandoc.json"
      ln -s $out/bin/ndpandoc $out/bin/pandoc
    '';
  }) { config = defaultConfig; }
