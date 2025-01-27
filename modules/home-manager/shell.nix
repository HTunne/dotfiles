{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    fd
    R
    ripgrep
    wget
    (writeShellApplication {
      name = "ex";
      runtimeInputs = [gnutar bzip2 unrar gzip unzip p7zip];
      text = ''
        if [ -f "$1" ] ; then
          case $1 in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *)           echo "'$1' cannot be extracted via ex" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      '';
    })
  ];

  programs.bat.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      more = "less";
      mnt = "udisksctl mount -b";
      umnt = "udisksctl unmount -b";
      ssh = "TERM=xterm-256color ssh";
      ls = "eza --git";
      la = "eza -a --git";
      ll = "eza -l --git";
      lt = "eza -l -snew --git";
      lr = "eza -l --tree --level=3 --git";
      tree = "eza -l --tree --git";
      cdg = "cd $\(git rev-parse --show-toplevel\)";
      calc = "R --no-save -q";
      gst = "git status";
      hms = "home-manager switch --flake ~/.config/dotfiles#$\(hostname\)";
      nxs = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#$\(hostname\)";
    };
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    initExtra = "set -o vi";
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      cat = "bat";
      mnt = "udisksctl mount -b";
      umnt = "udisksctl unmount -b";
      ssh = "TERM=xterm-256color ssh";
      la = "ls -a";
      ll = "ls -l";
      # lt = "ls -l | sort-by modified --reverse";
      # tree = "ls | tree";
      cdg = "cd (git rev-parse --show-toplevel)";
      calc = "R --no-save -q";
      gst = "git status";
      hms = "home-manager switch --flake ~/.config/dotfiles#(hostname)";
      nxs = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#(hostname)";
    };
    configFile.text = ''
      const color_palette = {
        rosewater: "#f5e0dc"
        flamingo: "#f2cdcd"
        pink: "#f5c2e7"
        mauve: "#cba6f7"
        red: "#f38ba8"
        maroon: "#eba0ac"
        peach: "#fab387"
        yellow: "#f9e2af"
        green: "#a6e3a1"
        teal: "#94e2d5"
        sky: "#89dceb"
        sapphire: "#74c7ec"
        blue: "#89b4fa"
        lavender: "#b4befe"
        text: "#cdd6f4"
        subtext1: "#bac2de"
        subtext0: "#a6adc8"
        overlay2: "#9399b2"
        overlay1: "#7f849c"
        overlay0: "#6c7086"
        surface2: "#585b70"
        surface1: "#45475a"
        surface0: "#313244"
        base: "#1e1e2e"
        mantle: "#181825"
        crust: "#11111b"
      }

      export def main [] { return {
        separator: $color_palette.overlay0
        leading_trailing_space_bg: { attr: "n" }
        header: { fg: $color_palette.blue attr: "b" }
        empty: $color_palette.lavender
        bool: $color_palette.lavender
        int: $color_palette.peach
        duration: $color_palette.text
        filesize: {|e|
            if $e < 1mb {
              $color_palette.green
          } else if $e < 100mb {
              $color_palette.yellow
          } else if $e < 500mb {
              $color_palette.peach
          } else if $e < 800mb {
              $color_palette.maroon
          } else if $e > 800mb {
              $color_palette.red
          }
        }
        date: {|| (date now) - $in |
          if $in < 1hr {
              $color_palette.green
          } else if $in < 1day {
              $color_palette.yellow
          } else if $in < 3day {
              $color_palette.peach
          } else if $in < 1wk {
              $color_palette.maroon
          } else if $in > 1wk {
              $color_palette.red
          }
        }
        range: $color_palette.text
        float: $color_palette.text
        string: $color_palette.text
        nothing: $color_palette.text
        binary: $color_palette.text
        cellpath: $color_palette.text
        row_index: { fg: $color_palette.mauve attr: "b" }
        record: $color_palette.text
        list: $color_palette.text
        block: $color_palette.text
        hints: $color_palette.overlay1
        search_result: { fg: $color_palette.red bg: $color_palette.text }

        shape_and: { fg: $color_palette.pink attr: "b" }
        shape_binary: { fg: $color_palette.pink attr: "b" }
        shape_block: { fg: $color_palette.blue attr: "b" }
        shape_bool: $color_palette.teal
        shape_custom: $color_palette.green
        shape_datetime: { fg: $color_palette.teal attr: "b" }
        shape_directory: $color_palette.teal
        shape_external: $color_palette.teal
        shape_externalarg: { fg: $color_palette.green attr: "b" }
        shape_filepath: $color_palette.teal
        shape_flag: { fg: $color_palette.blue attr: "b" }
        shape_float: { fg: $color_palette.pink attr: "b" }
        shape_garbage: { fg: $color_palette.text bg: $color_palette.red attr: "b" }
        shape_globpattern: { fg: $color_palette.teal attr: "b" }
        shape_int: { fg: $color_palette.pink attr: "b" }
        shape_internalcall: { fg: $color_palette.teal attr: "b" }
        shape_list: { fg: $color_palette.teal attr: "b" }
        shape_literal: $color_palette.blue
        shape_match_pattern: $color_palette.green
        shape_matching_brackets: { attr: "u" }
        shape_nothing: $color_palette.teal
        shape_operator: $color_palette.peach
        shape_or: { fg: $color_palette.pink attr: "b" }
        shape_pipe: { fg: $color_palette.pink attr: "b" }
        shape_range: { fg: $color_palette.peach attr: "b" }
        shape_record: { fg: $color_palette.teal attr: "b" }
        shape_redirection: { fg: $color_palette.pink attr: "b" }
        shape_signature: { fg: $color_palette.green attr: "b" }
        shape_string: $color_palette.green
        shape_string_interpolation: { fg: $color_palette.teal attr: "b" }
        shape_table: { fg: $color_palette.blue attr: "b" }
        shape_variable: $color_palette.pink

        background: $color_palette.base
        foreground: $color_palette.text
        cursor: $color_palette.blue
      }}


      $env.config = {
        show_banner: false,
        edit_mode: vi
      }

      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.PROMPT_INDICATOR_VI_NORMAL = ""
    '';
  };

  programs.bashmount.enable = true;

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    stdlib = ''
      layout_poetry() {
         if [[ ! -f pyproject.toml ]]; then
           log_error 'No pyproject.toml found.  Use `poetry new` or `poetry init` to create one first.'
           exit 2
         fi

         local VENV=$(dirname $(poetry run which python))
         export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
         export POETRY_ACTIVE=1
         PATH_add "$VENV"
       }
    '';
  };

  programs.eza = {
    enable = true;
  };

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.tealdeer.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    options = ["--cmd" "cd"];
  };
}
