{ pkgs }:
let
  ignoreFile =
    pkgs.writeText "gitignore" (builtins.concatStringsSep "\n" default.ignore);
  default = {
    user = {
      email = "newdawn.v0.0+git@gmail.com";
      name = "NewDawn0";
      signingkey = "8B1ED061D1C000363CF3E855064E70D1BD9280AC";
    };
    ignore = [
      # General
      ".DS_Store"
      ".idea"
      "*.swp"
      # Lang
      "node_modules/"
      "npm-debug.log"
      "__pycache__"
      ".ipynb_checkpoints"
      "pytest_cache"
      ".mypy_cache"
      ".egg-info"
      ".ccls-cache/"
      "*.pyc"
      ".dSYM"
      ".o"
      "result"
      "target/"
    ];
    config = {
      alias = {
        br = "branch";
        ca = "commit --amend";
        ch = "checkout";
        cm = "commit -m";
        df = "diff";
        pl = "pull";
        pu = "push";
        re = "restore";
        root = "rev-parse --show-toplevel";
        st = "status";
        untag = ''!sh -c 'git tag -d "$1" && git push origin -d $1' -'';
      };
      core = {
        pager = "${pkgs.delta}/bin/delta";
        excludesFile = "${ignoreFile}";
      };
      commit.gpgsign = true;
      delta.side-by-side = true;
      init.defaultBranch = "main";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      pull.rebase = true;
      push.autoSetupRemote = true;
      tag.gpgSign = true;
      user = default.user;
    };
  };
  cfgToml = pkgs.stdenvNoCC.mkDerivation {
    name = "git-configs";
    src = null;
    dontUnpack = true;
    dontBuild = true;
    configFile = (pkgs.formats.toml { }).generate "config.toml" default.config;
    installPhase = ''
      install -Dm644 $configFile $out/share/git/config.toml
    '';
  };
in pkgs.symlinkJoin {
  name = "ndgit";
  paths = with pkgs;
    [
      cfgToml
      (writeShellApplication {
        name = "ndgit";
        text = ''
          export GIT_CONFIG_GLOBAL="${cfgToml}/share/git/config.toml"
          ${git}/bin/git "$@"
        '';
      })
    ] ++ lib.optional stdenv.isDarwin [ pinentry_mac ]
    ++ lib.optional stdenv.isLinux [ pinentry-qt ];
  postInstall = ''
    ln -s $out/bin/ndgit $out/bin/git
  '';
}
