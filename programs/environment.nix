{ pkgs }:
let
  cfg = {
    starship = import ./starship.nix { inherit pkgs; };
    fastfetch = import ./fastfetch.nix { inherit pkgs; };
  };
in pkgs.symlinkJoin {
  name = "shell-env-pkgs";
  paths = with pkgs; [
    # Default
    coreutils
    curl
    fd
    ffmpeg
    file
    gh
    gnupg
    gnused
    killall
    less
    ndtmux
    openssh
    openssh
    pass
    pkg-config
    qemu
    ripgrep
    wget
    # Extra
    colima
    docker
    figlet
    imagemagick
    license-cli
    onefetch
  ];
}
