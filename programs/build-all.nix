{ pkgs }:
pkgs.writeShellApplication {
  name = "build-all";
  runtimeInputs = with pkgs; [ jq ];
  text = ''
        helpOpt() {
          echo "build-all [OPTIONS] <flake-path (Optional)>

    OPTIONS:
      h, help, -h, --help   Show this help message
      a, all                Build all packages
      p, packages           Build all packages
      o, overlays           Build all overlays"
        }

        packagesOpt() {
          local hasDefault
          local path
          local pkgs
          hasDefault=false
          if [[ $# -eq 0 ]]; then
            path="$(pwd)"
            echo "No flake path provided"
            echo "-> Using path: '.'"
          else
            echo "Using provided flake path: '$1'"
            path="$(realpath "$1")"
          fi
          echo "Evaluating packages..."
          pkgs="$(nix flake show --all-systems --json "$path" | jq -r '.packages."x86_64-linux" | keys[]')"
          echo "Building packages..."
          for pkg in $pkgs; do
            if [[ "$pkg" == "default" ]]; then
              hasDefault=true
              continue
            fi
            echo "-> Building package: $pkg"
            nix build ".#$pkg" || (echo "Failed to build $pkg" && exit 1)
          done
          if "$hasDefault"; then
            echo "-> Building package: default"
            nix build ".#default" || (echo "Failed to build default" && exit 1)
          fi
        }

        allOpt() {
          echo "Building all attributes..."
          packagesOpt "$@"
        }

        main() {
          if [[ $# -eq 0 ]]; then
            echo "No arguments provided"
            echo  "-> Using 'all' argument"
            allOpt
          fi
          if [[ $# -gt 2 ]]; then
            echo -e "Too many arguments provided\n"
            helpOpt
            exit 1
          fi
          case "$1" in
            "a"|"all")
              shift
              allOpt "$@" ;;
            "p"|"packages")
              shift
              packagesOpt "$@" ;;
            "h"|"help"|"-h"|"--help")
              helpOpt
              exit 0 ;;
            *)
              echo -e "Invalid argument: '$1'\n"
              helpOpt
              exit 1 ;;
          esac
        }

        main "$@"
  '';
}
