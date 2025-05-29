{ pkgs }:
let
  # Custom wrapped programs
  a = {
    bat = import ./ndbat.nix { inherit pkgs; };
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
    "\n" + concatStringsSep "\n" (map (p: "source ${p}") paths) + "\n";

  # Environment setup
  zshEnv = mkEnv {
    EDITOR = "nvim";
    GIT_CONFIG_GLOBAL = "${a.git}/share/config.toml";
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
    ls = "eza --git --icons";
    la = "eza --git --icons -a";
    ll = "eza --git --icons -l";
    lt = "eza --git --icons --tree";
    lta = "eza --git --icons --tree -a";
    mv = "mv -i";
    neofetch = "fastfetch";
    nix-cl = ''
      fd -t l -H "^result$" ~/GitHub | xargs -I{} rm {} && fd -t d -H ^target ~/GitHub | xargs -I{} "cd {} && cargo clean"'';
    nix-gc = "nix-store --gc && nix-store --optimize";
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
    "${pkgs.dir-stack}/share/dirStack/SOURCE_ME.sh"
    "${pkgs.up}/share/up/SOURCE_ME.sh"
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
    eval "$(fzf --zsh)"
    eval "$(starship init zsh)"
    eval "$(zoxide init zsh)"

    # Startup action
    ${pkgs.pac-asm}/bin/pac
  '';
  envBuilder = pkgs.runCommandNoCC "ndzsh-envBuilder" {
    source = pkgs.writeShellScript "SOURCE_ME.sh" (zshEnv + "\n" + zshRC);
    zshEnv = pkgs.writeShellScript "zshenv" zshEnv;
    zshRC = pkgs.writeShellScript "zshrc" zshRC;
  } ''
    mkdir -p $out/share/ndzsh
    install -Dm644 $source $out/share/ndzsh/SOURCE_ME.sh
    install -Dm644 $zshEnv $out/share/ndzsh/.zshenv
    install -Dm644 $zshRC  $out/share/ndzsh/.zshrc
  '';
  ndzsh = pkgs.writeShellApplication {
    name = "ndzsh";
    text = ''
      export ZDOTDIR="${envBuilder}/share/ndzsh"
      exec ${pkgs.zsh}/bin/zsh "$@"
    '';
  };
  # Environment files
in pkgs.symlinkJoin {
  name = "ndzsh";
  paths = let p = pkgs;
  in [
    envBuilder
    ndzsh
    # Pkgs (as: 'p')
    p.cargo
    p.delta
    p.dir-stack
    p.direnv
    p.eza
    p.fzf
    p.jq
    p.pac-asm
    p.up
    p.zoxide
    # Customised programs (as: 'a')
    a.bat
    a.fastfetch
    a.git
    a.starship
  ];
  postInstall = ''
    mkdir -p $out/share/
    ln -s $out/bin/ndzsh $out/bin/zsh
  '';
}
