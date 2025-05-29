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
          build-all = self.packages.${prev.system}.build-all;
          ndbat = self.packages.${prev.system}.ndbat;
          ndbtm = self.packages.${prev.system}.ndbtm;
          ndenv = self.packages.${prev.system}.ndenv;
          ndfastfetch = self.packages.${prev.system}.ndfastfetch;
          ndgit = self.packages.${prev.system}.ndgit;
          ndjq = self.packages.${prev.system}.ndjq;
          ndpandoc = self.packages.${prev.system}.ndpandoc;
          ndstarship = self.packages.${prev.system}.ndstarship;
          ndzsh = self.packages.${prev.system}.ndzsh;
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
            pname = "zsh";
            paths = let progs = getProgs pkgs;
            in map (e: progs.${e}) (builtins.attrNames progs);
            shellHook = ''
              export ZDOTDIR="$out/share/ndzsh"
              exec $out/bin/zsh "$@"
            '';
          };
        });
    };
}
