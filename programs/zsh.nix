{ pkgs }:
let
  cfg = {
    starship = import ./starship.nix { inherit pkgs; };
    fastfetch = import ./fastfetch.nix { inherit pkgs; };
  };
  jq = {
    null = "1;30";
    false = "0;37";
    true = "0;37";
    numbers = "0;37";
    strings = "0;32";
    arrays = "1;37";
    objects = "1;37";
  };
in pkgs.stdenvNoCC.mkDerivation {
  name = "zsh-config";
  src = null;
  dontBuild = true;
  dontUnpack = true;
  text = pkgs.writeShellScript "SOURCE_ME" ''
    # ZSH
    HISTSIZE=10000
    SAVEHIST=10000
    setopt HIST_EXPIRE_DUPS_FIRST
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
    setopt HIST_FIND_NO_DUPS
    setopt HIST_SAVE_NO_DUPS
    zmodload zsh/complist
    autoload -U compinit; compinit
    _comp_options+=(globdots)
    zstyle ':completion:*' menu select
    # Plugins
    source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
    source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
    source ${pkgs.up}/share/SOURCE_ME.sh
    source ${pkgs.dir-stack}/share/SOURCE_ME.sh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#aeabdf,bg=none,bold,underline"

    bindkey '^ ' autosuggest-accept
    bindkey -v
    autopair-init
    # Env vars
    EDITOR="nvim"
    VISUAL="nvim"
    PAGER="less"
    JQ_COLORS="${jq.null}:${jq.false}:${jq.true}:${jq.numbers}:${jq.strings}:${jq.arrays}:${jq.objects}";
    # Inits
    eval "$(${cfg.starship}/bin/starship init zsh)"
    eval "$(${pkgs.fzf}/bin/fzf --zsh)"
    eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    # Aliases
    alias fetch="${cfg.fastfetch}/bin/fastfetch"
    alias neofetch="${cfg.fastfetch}/bin/fastfetch"
    alias cd="z"
    alias cp="cp -i";
    alias grep="grep --color=always";
    alias la="lsd -A"
    alias ll="lsd -l"
    alias ls="lsd";
    alias lt="lsd --tree"
    alias mv="mv -i";
    alias nixgc="nix-store --gc && nix-store --optimize";
    alias regit="mv tmp/.git . && rmdir tmp";
    alias ungit="mkdir -p tmp && mv .git tmp/";
    # Startup
    ${pkgs.pac-asm}/bin/pac
  '';
  installPhase = ''
    mkdir -p $out/share
    cp $text $out/share/SOURCE_ME.sh
  '';
}
