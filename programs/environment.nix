{ pkgs }:
pkgs.symlinkJoin {
  name = "extra-env";
  paths = with pkgs; [
    # Default
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
    uutils-coreutils-noprefix
    wget
    # Extra
    colima
    delta
    docker
    figlet
    imagemagick
    kill-name
    license-cli
    onefetch
    rusty-man
    speedtest-go
  ];
}
