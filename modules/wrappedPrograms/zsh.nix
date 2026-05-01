{
  inputs,
  self,
  lib,
  ...
}: {
  flake.wrappers.zsh = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.zsh];
    # pkgs.config.allowUnfree = true;
    extraPackages = [
      inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.neovim-dynamic
      pkgs.bashmount
      pkgs.bat
      pkgs.bear
      pkgs.bottom
      pkgs.carapace
      pkgs.commitizen
      pkgs.curl
      pkgs.delta
      pkgs.direnv
      pkgs.dust
      pkgs.dust
      pkgs.dysk
      pkgs.eza
      pkgs.fd
      pkgs.file
      pkgs.fzf
      pkgs.imagemagick
      pkgs.jq
      pkgs.killall
      pkgs.libqalculate
      pkgs.mcfly
      pkgs.ncdu
      pkgs.ripgrep
      pkgs.starship
      pkgs.tealdeer
      pkgs.unzip
      pkgs.wget
      pkgs.zip
      pkgs.zoxide
      self.packages.${pkgs.stdenv.hostPlatform.system}.qalc
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
    env = {
      EDITOR = lib.getExe inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.neovim-dynamic;
    };
    zshAliases = {
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
      hms = "home-manager switch --flake \"$\{HOME\}/.config/dotfiles#$\(hostname\)\" && home-manager news --flake \"$\{HOME\}/.config/dotfiles#$\(hostname\)\"";
      nxs = "sudo nixos-rebuild switch --flake \"$\{HOME\}/.config/dotfiles#$\(hostname\)\"";
    };
    zshrc.content = ''
      HISTFILE="$HOME/.zsh_history"
      HISTSIZE=10000
      SAVEHIST=10000
      setopt autocd extendedglob nomatch notify

      # vi mode
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # starship
      eval "$(starship init zsh)"

      # carapace
      autoload -Uz compinit
      compinit -u
      # export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
      # zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      # source <(carapace _carapace)

      # direnv
      eval "$(direnv hook zsh)"

      #zoxide
      eval "$(zoxide init zsh --cmd cd)"

      # Set up fzf key bindings and fuzzy completion
      autoload -Uz add-zsh-hook
      _fzf_init() {
        source <(fzf --zsh)
      }
      add-zsh-hook -Uz precmd _fzf_init
    '';
  };
}
