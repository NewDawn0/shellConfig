{ pkgs }:
pkgs.symlinkJoin {
  name = "ndbtm";
  paths = [ pkgs.bottom ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  text = (pkgs.formats.toml { }).generate "btm.toml" {
    flags = {
      avg_cpu = true;
      battery = true;
      colors = { low_battery_color = "red"; };
      enable_gpu_memory = true;
      hide_table_gap = false;
      hide_time = true;
      rate = "1s";
      temperature_type = "c";
    };
  };
  postBuild = ''
    mv $out/bin/btm $out/bin/ndbtm
    wrapProgram $out/bin/ndbtm \
      --add-flags "-C $text"
    ln -s $out/bin/ndbtm $out/bin/btm
  '';
}
