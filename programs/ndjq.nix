{ pkgs }:
let
  defaultTheme = {
    null = "1;35";
    false = "0;31";
    true = "0;32";
    numbers = "0;33";
    strings = "0;32";
    arrays = "1;36";
    objects = "1;36";
  };
  jqWrapper = theme:
    pkgs.writeShellApplication {
      name = "ndjq";
      text = ''
        export JQ_COLORS="${theme.null}:${theme.false}:${theme.true}:${theme.numbers}:${theme.strings}:${theme.arrays}:${theme.objects}"
        exec ${pkgs.jq}/bin/jq "$@"
      '';
    };
  jqFinal = { theme }:
    pkgs.stdenvNoCC.mkDerivation {
      name = "jq-final";
      pname = "jq";
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        install -Dm755 ${jqWrapper theme}/bin/ndjq $out/bin/ndjq
        ln      -s     $out/bin/ndjq               $out/bin/jq
      '';
    };
in pkgs.lib.makeOverridable jqFinal { theme = defaultTheme; }
