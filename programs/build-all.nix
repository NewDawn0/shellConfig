{ pkgs }:
pkgs.writeShellApplication {
  name = "build-all";
  runtimeInputs = with pkgs; [ jq ];
  text = ''
    nix flake show --all-systems --json | jq -r '.packages."x86_64-linux" | keys[]' | while read -r pkg; do
        echo "Building package: $pkg"
        nix build ".#$pkg" || (echo "Failed to build $pkg" && exit 1)
    done
  '';
}
