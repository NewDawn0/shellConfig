{ pkgs }:
let
  jq = {
    null = "1;30";
    false = "0;37";
    true = "0;37";
    numbers = "0;37";
    strings = "0;32";
    arrays = "1;37";
    objects = "1;37";
  };
in pkgs.symlinkJoin {
  name = "ndjq";
  paths = [
    (pkgs.writeShellApplication {
      name = "ndjq";
      text = ''
        export JQ_COLORS="${jq.null}:${jq.false}:${jq.true}:${jq.numbers}:${jq.strings}:${jq.arrays}:${jq.objects}"
        exec ${pkgs.jq}/bin/jq "$@"
      '';
    })
  ];
  postInstall = ''
    ln -s $out/bin/ndjq $out/bin/jq
  '';
}
