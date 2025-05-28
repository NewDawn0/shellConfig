{ pkgs }:
let
  # Custom wrapped programs
  progs = {
    bat = import ./bat.nix { inherit pkgs; };
    fastfetch = import ./fastfetch.nix { inherit pkgs; };
    git = import ./git-pkg.nix { inherit pkgs; };
    starship = import ./starship.nix { inherit pkgs; };
  };

  # Type ✨checked Nix✨
  mkEnv = env:
    with builtins;
    assert isAttrs env;
    "\n" + concatStringsSep "\n"
    (map (name: "export ${name}='${toString env.${name}}'") (attrNames env));

  mkAliases = aliases:
    with builtins;
    assert isAttrs aliases;
    "\n" + concatStringsSep "\n"
    (map (name: "alias ${name}='${toString aliases.${name}}'")
      (attrNames aliases));

  mkOpts = opts:
    with builtins;
    assert isList opts;
    "\n" + concatStringsSep "\n" (map (opt: "setopt ${opt}") opts);

  mkSource = paths:
    with builtins;
    assert isList paths;
    "\n" + concatStringsSep "\n" (map (p: "source ${p}") paths) + "\n";

  # Environment setup
  zshEnv = mkEnv {
    EDITOR = "nvim";
    GIT_CONFIG_GLOBAL = "${progs.git}/share/config.toml";
    HISTSIZE = 10000;
    PAGER = "less";
    SAVEHIST = 10000;
    SHELL = "${pkgs.zsh}/bin/zsh";
    VISUAL = "nvim";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#aeabdf,bg=none,bold,underline";
  } + mkAliases {
    cat = "bat";
    cd = "z";
    cp = "cp -i";
    diff = "delta";
    grep = "grep --color=always";
    la = "eza --git --icons -a";
    ll = "eza --git --icons -l";
    ls = "eza --git --icons";
    lt = "eza --git --icons -T";
    mv = "mv -i";
    neofetch = "fastfetch";
    nix-gc = "nix-store --gc && nix-store --optimize";
    nix-cl = ''
      fd -t l -H "^result$" ~/GitHub | xargs -I{} rm {} && fd -t d -H ^target ~/GitHub | xargs -I{} "cd {} && cargo clean"'';
    regit = "mv tmp/.git . && rmdir tmp";
    ungit = "mkdir -p tmp && mv .git tmp/";
  } + mkOpts [
    "HIST_EXPIRE_DUPS_FIRST"
    "HIST_FIND_NO_DUPS"
    "HIST_IGNORE_ALL_DUPS"
    "HIST_IGNORE_DUPS"
    "HIST_IGNORE_SPACE"
    "HIST_SAVE_NO_DUPS"
  ] + mkSource [
    "${pkgs.dir-stack}/share/SOURCE_ME.sh"
    "${pkgs.up}/share/SOURCE_ME.sh"
    "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh"
    "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
    "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
  ] + ''
    zmodload zsh/complist
    autoload -U compinit; compinit
    _comp_options+=(globdots)
    zstyle ':completion:*' menu select

    bindkey '^ ' autosuggest-accept
    bindkey -v
    autopair-init
  '';
  # Runtime config
  zshRC = ''
    # Init shell tools
    eval "$(${pkgs.fzf}/bin/fzf --zsh)"
    eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    eval "$(${progs.starship}/bin/starship init zsh)"

    # Startup action
    ${pkgs.pac-asm}/bin/pac
  '';

  # Unified files in `$out/share/ndzsh` directory
  ndzsh = pkgs.runCommandNoCC "ndzsh" {
    source = pkgs.writeShellScript "SOURCE_ME.sh" (zshEnv + "\n" + zshRC);
    zshenv = pkgs.writeShellScript "zshenv" zshEnv;
    zshrc = pkgs.writeShellScript "zshrc" zshRC;
  } ''
    mkdir -p $out/share/ndzsh
    install -Dm644 $source $out/share/ndzsh/SOURCE_ME.sh
    install -Dm644 $zshenv $out/share/ndzsh/.zshenv
    install -Dm644 $zshrc  $out/share/ndzsh/.zshrc
  '';

  # Fully wrapped executable
  zsh = pkgs.writeShellApplication {
    name = "zsh";
    runtimeInputs = with pkgs; [
      direnv
      eza
      fzf
      jq
      pac-asm
      up
      zoxide
      # Custom apps
      progs.bat
      progs.fastfetch
      progs.git
      progs.starship
    ];
    text = ''
      export ZDOTDIR="${ndzsh}/share/ndzsh"
      exec ${pkgs.zsh}/bin/zsh "$@"
    '';
  };
in zsh
