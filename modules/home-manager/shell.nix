{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    fd
    R
    ripgrep
    wget
    (writeShellApplication {
      name = "ex";
      runtimeInputs = [ gnutar bzip2 unrar gzip unzip p7zip ];
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
      hms = "home-manager switch --flake ~/.config/dotfiles#default";
      nxs = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#default";
      hmsu = "home-manager switch --recreate-lock-file --flake ~/.config/dotfiles#default";
      nxsu = "sudo nixos-rebuild switch --recreate-lock-file --flake ~/.config/dotfiles#default";
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
  };

  programs.tealdeer.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd" "cd" ];
  };

}
