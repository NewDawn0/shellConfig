{
  description = "Fully fletched shell configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils = {
      url = "github:NewDawn0/nixUtils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      lib = { inherit progAttrs; };
      overlays.default = final: prev:
        ({
          bat = self.packages.${prev.system}.bat;
          bottom = self.packages.${prev.system}.bottom;
          build-all = self.packages.${prev.system}.build-all;
          environment = self.packages.${prev.system}.environment;
          fastfetch = self.packages.${prev.system}.fastfetch;
          git-pkg = self.packages.${prev.system}.git-pkg;
          jq-pkg = self.packages.${prev.system}.jq-pkg;
          # pandoc = self.packages.${prev.system}.pandoc;
          starship = self.packages.${prev.system}.starship;
          zsh = self.packages.${prev.system}.zsh;
        } // {
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
