{
  description = "Fully fletched shell configuration";

  inputs = {
    utils.url = "github:NewDawn0/nixUtils";
    ds = {
      url = "github:NewDawn0/dirStack";
      inputs.utils.follows = "utils";
    };
    kill-name = {
      url = "github:NewDawn0/killName";
      inputs.utils.follows = "utils";
    };
    pac = {
      url = "github:NewDawn0/pac";
      inputs.utils.follows = "utils";
    };
    tmux-cfg = {
      url = "github:NewDawn0/tmuxConfig";
      inputs.utils.follows = "utils";
    };
    up = {
      url = "github:NewDawn0/up";
      inputs.utils.follows = "utils";
    };
  };

  outputs = { self, utils, ... }@inputs:
    let
      getProgs = pkgs: import ./programs { inherit pkgs; };
      progAttrs = pkgs:
        let progs = getProgs pkgs;
        in pkgs.lib.genAttrs (builtins.attrNames progs) (e: progs.${e});
    in {
      overlays.default = final: prev:
        (progAttrs prev // { ndshell = self.packages.${prev.system}.default; });
      packages = utils.lib.eachSystem {
        overlays = with inputs; [
          ds.overlays.default
          kill-name.overlays.default
          pac.overlays.default
          tmux-cfg.overlays.default
          up.overlays.default
        ];
      } (pkgs:
        (progAttrs pkgs) // {
          default = pkgs.symlinkJoin {
            name = "ndshell";
            paths = let progs = getProgs pkgs;
            in map (e: progs.${e}) (builtins.attrNames progs);
            shellHook = ''
              source $out/share/SOURCE_ME.sh
            '';
          };
        });
    };
}
