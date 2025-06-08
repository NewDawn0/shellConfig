{ pkgs }:
let
  # Default config
  defaultCfg = {
    gitignore = [
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
    gitconfig = {
      user = {
        email = "newdawn.v0.0+git@gmail.com";
        name = "NewDawn0";
        signingkey = "8B1ED061D1C000363CF3E855064E70D1BD9280AC";
      };
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
      core.pager = "${pkgs.delta}/bin/delta";
      commit.gpgsign = true;
      delta.side-by-side = true;
      init.defaultBranch = "main";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      pull.rebase = true;
      push.autoSetupRemote = true;
      tag.gpgSign = true;
    };
  };
  gitCfg = { config }:
    let
      gitignore = pkgs.writeText "gitignore"
        (builtins.concatStringsSep "\n" config.gitignore);
      gitconfig = (pkgs.formats.toml { }).generate "config.toml"
        (config.gitconfig // {
          core.excludesFile = pkgs.writeText "gitignore"
            (builtins.concatStringsSep "\n" defaultCfg.gitignore);
        });
    in pkgs.stdenvNoCC.mkDerivation {
      name = "git-config";
      src = null;
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        install -Dm644 ${gitignore} $out/share/ndgit/gitignore
        install -Dm644 ${gitconfig} $out/share/ndgit/config.toml
      '';
    };
  gitPkg = { config }:
    pkgs.writeShellApplication {
      name = "ndgit";
      runtimeInputs = with pkgs;
        [ pkgs.gnupg ] ++ lib.optionals stdenv.isDarwin [ pinentry_mac ]
        ++ lib.optionals stdenv.isLinux [ pinentry-qt ];
      text = ''
        export GIT_CONFIG_GLOBAL="${
          gitCfg { inherit config; }
        }/share/ndgit/config.toml"
        ${pkgs.git}/bin/git "$@"
      '';
    };
  gitFinal = { config }:
    assert builtins.isAttrs config;
    let
      g = gitPkg { inherit config; };
      c = gitCfg { inherit config; };
    in pkgs.stdenvNoCC.mkDerivation {
      name = "git-final";
      pname = "git";
      src = null;
      dontUnpack = true;
      dontBuild = true;
      installPhase = ''
        install -Dm755 ${g}/bin/ndgit               $out/bin/ndgit
        install -Dm644 ${c}/share/ndgit/gitignore   $out/share/ndgit/gitignore
        install -Dm644 ${c}/share/ndgit/config.toml $out/share/ndgit/config.toml
        ln      -s     $out/bin/ndgit               $out/bin/git
      '';
    };
in pkgs.lib.makeOverridable gitFinal { config = defaultCfg; }
