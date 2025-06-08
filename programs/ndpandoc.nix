{ pkgs }:
let
  defaultConfig = {
    metadata = {
      author = "NewDawn0";
      language = "en";
      toc = true;
    };
  };
  pandocFinal = { config }:
    let
      json = (pkgs.formats.json { }).generate "pandoc.json" config;
      wrapper = pkgs.writeShellScriptBin "ndpandoc" ''
        exec ${pkgs.pandoc}/bin/pandoc --defaults ${json} "$@"
      '';
    in pkgs.stdenvNoCC.mkDerivation {
      name = "pandoc-final";
      pname = "pandoc";
      src = null;
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        install -Dm644 ${json}                 $out/share/ndpandoc/pandoc.json
        install -Dm755 ${wrapper}/bin/ndpandoc $out/bin/ndpandoc
        ln      -s     $out/bin/ndpandoc       $out/bin/pandoc
      '';
    };
in pkgs.lib.makeOverridable pandocFinal { config = defaultConfig; }
