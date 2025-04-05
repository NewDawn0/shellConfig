{
  description = "Fully fletched shell configuration";

  inputs = {
    utils.url = "github:NewDawn0/nixUtils";
    ds = {
      url = "github:NewDawn0/dirStack";
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

  outputs = { self, utils, ... }@inputs: {
    overlays.default = final: prev: {
      ndshell = self.packages.${prev.system}.default;
    };
    packages = utils.lib.eachSystem {
      overlays = with inputs; [
        ds.overlays.default
        pac.overlays.default
        tmux-cfg.overlays.default
        up.overlays.default
      ];
    } (pkgs:
      let
        programs = import ./programs { inherit pkgs; };
        outPrograms =
          pkgs.lib.genAttrs (builtins.attrNames programs) (e: programs.${e});
      in outPrograms // {
        default = pkgs.symlinkJoin {
          name = "ndshell";
          paths = map (e: programs.${e}) (builtins.attrNames programs);
          shellHook = ''
            source $out/share/SOURCE_ME.sh
          '';
        };
      });
  };
}
