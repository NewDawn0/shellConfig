{ pkgs }:
let
  themes = {
    b16 = {
      fg0 = "#181818";
      p0 = "#ff767a";
      p1 = "#ff9268";
      p2 = "#86BBD8";
      p3 = "#55bcf7";
      p4 = "#aeabdf";
      p5 = "#da84e4";
      green = "#80dc7e";
      purple = "#da84e4";
      red = "#ff767a";
    };
    pastel-powerline = {
      fg0 = "#fafefc";
      p0 = "#9A348E";
      p1 = "#DA627D";
      p2 = "#FCA17D";
      p3 = "#86BBD8";
      p4 = "#06969A";
      p5 = "#33658A";
      green = "#76D274";
      purple = "#9A348E";
      red = "#DA627D";
    };
    gruvbox-dark = {
      fg0 = "#fbf1c7";
      p0 = "#d65d0e";
      p1 = "#d79921";
      p2 = "#689d6a";
      p3 = "#458588";
      p5 = "#3c3836";
      p4 = "#665c54";
      green = "#76D274";
      purple = "#b16286";
      red = "#FF7078";
    };
  };
  cfg = c: {
    "$schema" = "https://starship.rs/config-schema.json";
    format = ''
      [](${c.p0})$os$username[](bg:${c.p1} fg:${c.p0})$directory[](fg:${c.p1} bg:${c.p2})$git_branch$git_status[](fg:${c.p2} bg:${c.p3})$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:${c.p3} bg:${c.p4})$docker_context$conda[](fg:${c.p4} bg:${c.p5})$time[ ](fg:${c.p5})
      $line_break$character
    '';
    # General
    line_break.disabled = true;
    character = {
      disabled = false;
      success_symbol = "[❯](bold fg:${c.green})";
      error_symbol = "[❯](bold fg:${c.red})";
      vimcmd_symbol = "[](bold fg:${c.green})";
      vimcmd_replace_one_symbol = "[](bold fg:${c.p0})";
      vimcmd_replace_symbol = "[](bold fg:${c.p0})";
      vimcmd_visual_symbol = "[](bold fg:${c.p3})";
    };

    # Symbols
    os = {
      disabled = false;
      style = "bg:${c.p0} fg:${c.fg0}";
      symbols = {
        Alpine = "";
        Amazon = "";
        Android = "";
        Arch = "󰣇";
        Artix = "󰣇";
        CentOS = "";
        Debian = "󰣚";
        Fedora = "󰣛";
        Gentoo = "󰣨";
        Linux = "󰌽";
        Macos = "󰀵";
        Manjaro = "";
        Mint = "󰣭";
        Raspbian = "󰐿";
        RedHatEnterprise = "󱄛";
        Redhat = "󱄛";
        SUSE = "";
        Ubuntu = "󰕈";
        Windows = "󰍲";
      };
    };
    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:${c.p5}";
      format = "[[  $time ](fg:${c.fg0} bg:${c.p5})]($style)";
    };
    username = {
      show_always = true;
      style_user = "bg:${c.p0} fg:${c.fg0}";
      style_root = "bg:${c.p0} fg:${c.fg0}";
      format = "[ $user ]($style)";
    };
    directory = {
      style = "fg:${c.fg0} bg:${c.p1}";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
      substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = "󰝚 ";
        "Pictures" = " ";
        "Developer" = "󰲋 ";
      };
    };
    git_branch = {
      symbol = "";
      style = "bg:${c.p2}";
      format = "[[ $symbol $branch ](fg:${c.fg0} bg:${c.p2})]($style)";
    };
    git_status = {
      style = "bg:${c.p2}";
      format =
        "[[($all_status$ahead_behind )](fg:${c.fg0} bg:${c.p2})]($style)";
    };
    nodejs = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    c = {
      symbol = " ";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    rust = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    golang = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    php = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    java = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    kotlin = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    haskell = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    python = {
      symbol = "";
      style = "bg:${c.p3}";
      format = "[[ $symbol( $version) ](fg:${c.fg0} bg:${c.p3})]($style)";
    };
    docker_context = {
      symbol = "";
      style = "bg:${c.p5}";
      format = "[[ $symbol( $context) ](fg:#83a598 bg:${c.p5})]($style)";
    };
    conda = {
      style = "bg:${c.p5}";
      format = "[[ $symbol( $environment) ](fg:#83a598 bg:${c.p5})]($style)";
    };
  };
  starshipCfg =
    (pkgs.formats.toml { }).generate "starship.toml" (cfg themes.b16);
in pkgs.writeShellScriptBin "starship" ''
  STARSHIP_CONFIG="${starshipCfg}" ${pkgs.starship}/bin/starship "$@"
''
