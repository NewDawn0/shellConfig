{ pkgs }:
let
  defaultFlags = {
    avg_cpu = true;
    battery = true;
    colors = { low_battery_color = "red"; };
    enable_gpu_memory = true;
    hide_table_gap = false;
    hide_time = true;
    rate = "1s";
    temperature_type = "c";
  };
  btmFinal = { flags }:
    let
      toml = (pkgs.formats.toml { }).generate "bottom.toml" { flags = flags; };
      bin = pkgs.writeShellScriptBin "ndbtm" ''
        exec ${pkgs.bottom}/bin/btm -C ${toml} "$@"
      '';
    in pkgs.stdenvNoCC.mkDerivation {
      name = "ndbtm";
      src = null;
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        install -Dm644 ${toml}          $out/share/ndbtm/bottom.toml
        install -Dm755 ${bin}/bin/ndbtm $out/bin/ndbtm
        ln -s $out/bin/ndbtm $out/bin/btm
      '';
    };
in pkgs.lib.makeOverridable btmFinal { flags = defaultFlags; }
