# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
    keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # nixpkgs.overlays = [
  #   (self: super: {
  #     qtile-unwrapped = super.qtile-unwrapped.overrideAttrs(_: rec {
  #       postInstall = let
  #         qtileSession = ''
  #         [Desktop Entry]
  #         Name=Qtile Wayland
  #         Comment=Qtile on Wayland
  #         Exec=qtile start -b wayland
  #         Type=Application
  #         '';
  #         in
  #         ''
  #       mkdir -p $out/share/wayland-sessions
  #       echo "${qtileSession}" &gt; $out/share/wayland-sessions/qtile.desktop
  #       '';
  #       passthru.providedSessions = [ "qtile" ];
  #     });
  #   })
  # ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    windowManager.qtile.backend = "wayland";
    layout = "gb";
    xkbOptions = "eurosign:e,caps:escape";
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.mini = {
      enable = true;
      user = "h";
      extraConfig = ''
        [greeter]
        show-password-label = false
        [greeter-theme]
        background-image = ""
      '';
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable xremap
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "h" ];
  users.groups.input.members = [ "h" ];

  # Enable touchpad support (enabled default in most desktopManager).

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.h = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ly
    python311Packages.pywlroots
    python311Packages.pywayland
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

