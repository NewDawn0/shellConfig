{ pkgs }:
let
  cfg = {
    starship = import ./starship.nix { inherit pkgs; };
    fastfetch = import ./fastfetch.nix { inherit pkgs; };
  };
  dots = pkgs.stdenvNoCC.mkDerivation {
    name = "dots";
    src = null;
    dontUnpack = true;
    zshrc = pkgs.writeShellScript ".zshrc" ''
      # Inits
      eval "$(${cfg.starship}/bin/starship init zsh)"
      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      # Startup
      ${pkgs.pac-asm}/bin/pac
    '';
    zshenv = pkgs.writeShellScript ".zshenv" ''
      # ZSH
      SHELL=${pkgs.zsh}/bin/zsh
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
      # Keybinds & inits
      bindkey '^ ' autosuggest-accept
      bindkey -v
      autopair-init
      # Env vars
      EDITOR="nvim"
      VISUAL="nvim"
      PAGER="less"
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
    '';
    installPhase = ''
      mkdir -p $out/share/dots
      install -D $zshenv $out/share/dots/.zshenv
      install -D $zshrc  $out/share/dots/.zshrc
      cat $zshenv > $out/share/SOURCE_ME.sh
      cat $zshrc >> $out/share/SOURCE_ME.sh
    '';
  };
  bin = pkgs.writeShellScriptBin "zsh" ''
    export ZDOTDIR=${dots}/share/dots
    exec ${pkgs.zsh}/bin/zsh -i
  '';
in pkgs.symlinkJoin {
  name = "ndzsh";
  pname = "zsh";
  paths = [ dots bin ];
}
