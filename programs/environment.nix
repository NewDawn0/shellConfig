{ pkgs }:
pkgs.symlinkJoin {
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
    kill-name
    license-cli
    onefetch
    speedtest-go
  ];
}
