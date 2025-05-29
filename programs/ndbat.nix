{ pkgs }:
let
  wrapPkg = name: bin:
    pkgs.writeShellScriptBin name ''
      BAT_THEME="TwoDark" ${bin}/bin/${name} "$@"
    '';
in pkgs.symlinkJoin {
  name = "ndbat";
  paths = [
    (wrapPkg "bat" pkgs.bat)
    (wrapPkg "batman" pkgs.bat-extras.batman)
    (wrapPkg "batdiff" pkgs.bat-extras.batdiff)
  ];
  postInstall = ''
    ln -s $out/bin/ndbat $out/bin/bat
  '';
}
