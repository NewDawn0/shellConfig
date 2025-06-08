{ pkgs }:
let
  wrapPkg = theme: name: bin:
    pkgs.writeShellScriptBin name ''
      export BAT_THEME="${theme}"
      ${bin}/bin/${name} "$@"
    '';
  batFinal = { theme }:
    pkgs.pkgs.symlinkJoin {
      name = "bat-final";
      pname = "bat";
      paths = [
        (wrapPkg theme "bat" pkgs.bat)
        (wrapPkg theme "ndbat" pkgs.bat)
        (wrapPkg theme "batman" pkgs.bat-extras.batman)
        (wrapPkg theme "batdiff" pkgs.bat-extras.batdiff)
      ];
    };
in pkgs.lib.makeOverridable batFinal { theme = "TwoDark"; }
