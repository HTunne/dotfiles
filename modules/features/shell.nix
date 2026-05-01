{
  inputs,
  ...
}: {
  flake.homeModules.shell = {
    pkgs,
    lib,
    ...
  }: {
    home.sessionVariables = {
      EDITOR = lib.getExe inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.neovim-dynamic;
    };

    home.packages = [
      inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.neovim-dynamic
      pkgs.bear
      pkgs.commitizen
      pkgs.curl
      pkgs.dust
      pkgs.dysk
      pkgs.file
      pkgs.imagemagick
      pkgs.jq
      pkgs.killall
      pkgs.ncdu
      pkgs.starship
      pkgs.tealdeer
      pkgs.unzip
      pkgs.wget
      pkgs.zip
      (pkgs.writeShellApplication {
        name = "ex";
        runtimeInputs = [pkgs.gnutar pkgs.bzip2 pkgs.gzip pkgs.unzip pkgs.p7zip];
        text = ''
          if [ -f "$1" ] ; then
            case $1 in
              *.tar.bz2)   tar xjf "$1"   ;;
              *.tar.gz)    tar xzf "$1"   ;;
              *.bz2)       bunzip2 "$1"   ;;
              # *.rar)       unrar x "$1"   ;;
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

    programs.bash = {
      enable = true;
      shellAliases = {
        cat = "bat";
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
        gst = "git status";
        hms = "home-manager switch --flake ~/.config/dotfiles#$\(hostname\) && home-manager news --flake ~/.config/dotfiles#$\(hostname\)";
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

    programs.bashmount.enable = true;

    programs.bottom.enable = true;

    programs.carapace = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
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

    programs.bat.enable = true;

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.fd.enable = true;

    programs.fzf.enable = true;

    programs.ripgrep.enable = true;

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.tealdeer.enable = true;

    # programs.zellij = {
    #   enable = true;
    #   enableBashIntegration = true;
    # };

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = ["--cmd" "cd"];
    };
  };
}
