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
      mkPrograms = pkgs: import ./programs { inherit pkgs; };
      mkOut = { pkgs, fmt }:
        pkgs.lib.genAttrs (builtins.attrNames (mkPrograms pkgs)) fmt;
    in {
      overlays.default = final: prev:
        ((mkOut {
          pkgs = prev;
          fmt = e: self.packages.${prev.system}.${e};
        }) // {
          ndshell = self.packages.${prev.system}.default;
        });
      packages = utils.lib.eachSystem {
        overlays = with inputs; [
          ds.overlays.default
          kill-name.overlays.default
          pac.overlays.default
          tmux-cfg.overlays.default
          up.overlays.default
        ];
      } (pkgs:
        (mkOut {
          inherit pkgs;
          fmt = e: (mkPrograms pkgs).${e};
        }) // {
          default = pkgs.symlinkJoin {
            name = "ndshell";
            paths =
              map (e: (mkPrograms).${e}) (builtins.attrNames (mkPrograms));
            shellHook = ''
              source $out/share/SOURCE_ME.sh
            '';
          };
        });
    };
}
