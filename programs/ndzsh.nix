{ pkgs }:
let
  # Default config
  defaultConfig = {
    aliases = {
      # General
      cat = "bat";
      cd = "z";
      cp = "cp -i";
      diff = "delta";
      git = "${apps.git}/bin/git";
      grep = "grep --color=always";
      la = "eza --git --icons=always -a";
      ll = "eza --git --icons=always -l";
      ls = "eza --git --icons=always";
      lt = "eza --git --icons=always --tree";
      lta = "eza --git --icons=always --tree -a";
      mv = "mv -i";
      regit = "mv tmp/.git . && rmdir tmp";
      ungit = "mkdir -p tmp && mv .git tmp/";
      # Nix
      nix-cl = ''
        fd -t l -H "^result$" ~/GitHub | xargs -I{} rm {} && fd -t d -H ^target ~/GitHub | xargs -I{} "cd {} && cargo clean"'';
      nix-fu = "nix flake update";
      nix-gc = "nix-store --gc && nix-store --optimize";
      nix-so = "nix flake show";
      nix-re = "sudo "
        + (if pkgs.stdenv.isDarwin then "darwin-rebuild " else "nixos-rebuild")
        + " switch --flake";
    };
    envVars = {
      ANI_CLI_PLAYER = "mpv";
      EDITOR = "nvim";
      GIT_CONFIG_GLOBAL = "${apps.git}/share/ndgit/config.toml";
      HISTSIZE = 10000;
      PAGER = "less";
      PASSWORD_STORE_DIR = "~/GitHub/pass/";
      SAVEHIST = 10000;
      SHELL = "${pkgs.zsh}/bin/zsh";
      VISUAL = "nvim";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#aeabdf,bg=none,bold,underline";
    };
    extraEnv = ''
      zmodload zsh/complist
      autoload -U compinit; compinit
      _comp_options+=(globdots)
      zstyle ':completion:*' menu select
    '';
    extraRC = ''
      # Init shell tools
      eval "$(direnv    hook zsh)"
      eval "$(fzf       --zsh)"
      eval "$(starship  init zsh)"
      eval "$(zoxide    init zsh)"
      # Keybinds
      bindkey '^ ' autosuggest-accept
      bindkey -v
      autopair-init
      # Startup action
      ${pkgs.pac-asm}/bin/pac
    '';
    sourceFiles = [
      "${pkgs.dir-stack}/share/dirStack/SOURCE_ME.sh"
      "${pkgs.up}/share/up/SOURCE_ME.sh"
      "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh"
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
      "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
    ];
    shellOptions = [
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_FIND_NO_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_SAVE_NO_DUPS"
    ];
    extraPackages = [
      pkgs.cargo
      pkgs.delta
      pkgs.dir-stack
      pkgs.direnv
      pkgs.eza
      pkgs.fzf
      pkgs.jq
      pkgs.pac-asm
      pkgs.up
      pkgs.zoxide
    ];
  };
  # Custom wrapped programs (as: 'a' for apps)
  apps = {
    bat = import ./ndbat.nix { inherit pkgs; };
    btm = import ./ndbtm.nix { inherit pkgs; };
    fastfetch = import ./ndfastfetch.nix { inherit pkgs; };
    git = import ./ndgit.nix { inherit pkgs; };
    starship = import ./ndstarship.nix { inherit pkgs; };
  };

  # Type ✨checked Nix✨
  mkAliases = aliases:
    with builtins;
    assert isAttrs aliases;
    "\n" + concatStringsSep "\n"
    (map (name: "alias ${name}='${toString aliases.${name}}'")
      (attrNames aliases));

  mkEnv = env:
    with builtins;
    assert isAttrs env;
    "\n" + concatStringsSep "\n"
    (map (name: "export ${name}='${toString env.${name}}'") (attrNames env));

  mkOpts = opts:
    with builtins;
    assert isList opts;
    "\n" + concatStringsSep "\n" (map (opt: "setopt ${opt}") opts);

  mkSource = paths:
    with builtins;
    assert isList paths;
    "\n" + concatStringsSep "\n" (map (e: "source ${e}") paths);

  # Helper functions
  fwrite = name: text:
    assert builtins.isString name;
    pkgs.writeTextFile {
      inherit name;
      text = fwriteCheck text;
    };
  fwriteCheck = content:
    with builtins;
    if isString content && content != "" then
      content
    else if isPath content && pathExists content then
      readFile content
    else if isList content then
      concatStringsSep "\n" (map fwriteCheck content)
    else
      throw "here";
  # toString content;
  # Zsh dotfiles
  zshDots = { config }:
    let
      zshrc = fwrite "zshrc" config.extraRC;
      zshenv = fwrite "zshenv" [
        (mkSource config.sourceFiles)
        (mkEnv config.envVars)
        (mkAliases config.aliases)
        (mkOpts config.shellOptions)
        config.extraEnv
      ];
    in pkgs.runCommandNoCC "ndzsh-dots" { } ''
      install -Dm644 ${zshrc}  $out/share/ndzsh/.zshrc
      install -Dm644 ${zshenv} $out/share/ndzsh/.zshenv
      # Source file
      echo "#!${pkgs.runtimeShell}" >  SOURCE_ME.sh
      cat  $out/share/ndzsh/.zshenv >> SOURCE_ME.sh
      cat  $out/share/ndzsh/.zshrc  >> SOURCE_ME.sh
      install -Dm644 SOURCE_ME.sh $out/share/ndzsh/SOURCE_ME.sh
      # Zsh wrapper
      echo "#!${pkgs.runtimeShell}"              >  ndzsh
      echo "export ZDOTDIR=\"$out/share/ndzsh\"" >> ndzsh
      echo 'exec ${pkgs.zsh}/bin/zsh "$@"'       >> ndzsh
      install -Dm755 ndzsh $out/bin/ndzsh
      ln -s $out/bin/ndzsh $out/bin/zsh
    '';
  zshFinal = { config }:
    let cfg = defaultConfig // config;
    in pkgs.symlinkJoin {
      name = "ndzsh";
      paths = [
        (zshDots { config = cfg; })
        # Customised programs
        apps.bat
        apps.btm
        apps.fastfetch
        apps.git
        apps.starship
      ] ++ config.extraPackages;
    };
in pkgs.lib.makeOverridable zshFinal { config = defaultConfig; }
