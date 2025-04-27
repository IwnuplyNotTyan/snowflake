
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Virt
  users.groups.libvirtd.members = ["q"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # DNS
    services.stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        upstream_recursive_servers = [{
          address_data = "1.1.1.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        } {
          address_data = "1.0.0.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
          }];
        }];
      };
    };

  # Distrobox
  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "nixos";
  
  # Disk
  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true;

  # OpenCL
   hardware.graphics = { # hardware.opengl in 24.05
    enable = true;
    enable32Bit = true; # driSupport32Bit in 24.05
    extraPackages = with pkgs; [
      intel-compute-runtime
      rocmPackages.clr.icd
    ];
  };

  # Locale and timezone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Kyiv";
  i18n.extraLocaleSettings = {
  LC_ADDRESS = "uk_UA.UTF-8";
  LC_IDENTIFICATION = "uk_UA.UTF-8";
  LC_MEASUREMENT = "uk_UA.UTF-8";
  LC_MONETARY = "uk_UA.UTF-8";
  LC_NAME = "uk_UA.UTF-8";
  LC_NUMERIC = "uk_UA.UTF-8";
  LC_PAPER = "uk_UA.UTF-8";
  LC_TELEPHONE = "uk_UA.UTF-8";
  LC_TIME = "uk_UA.UTF-8";
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  
  # User
  users.users.q = {
    isNormalUser = true;
    description = "iwnuplylo";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      firefox
     ];
  };

  # Network
  networking.networkmanager.enable = true;

  # CUPS
  services.printing.enable = true;

  # Sound
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
  #media-session.enable = true;
  };

  musnix = {
    enable = true;
    alsaSeq.enable = false;
    soundcardPciId = "00:1f.3";
    rtirq = {
      # highList = "snd_hrtimer";
      resetAll = 1;
      prioLow = 0;
      enable = true;
      nameList = "rtc0 snd";
    };
  };

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.powerOnBoot = true;
  
  # X11 Enable
  services.xserver.enable = true;

  # Layout
  services.xserver = {
    xkb.layout = "us";
    xkbVariant = "";
  };
 
  # DM
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.lightdm.enable = false;

  # Touchpad 
  services.libinput.enable = true;

  # OpenSSH
  services.openssh.enable = true;
  
  # PKGS
  environment.systemPackages = with pkgs; [
  
  # Nix
  nvd
  nh
  nix-output-monitor

  # CLI & TUI
  distrobox
  doas
  neovim
  git
  ripgrep
  joshuto
  btop
  eza
  amfora
  zsh
  starship
  tmux
  bat
  bluetuith
  appimage-run

  # GUI
  telegram-desktop
  zathura
  kitty
  maim
  
  # Games
   #ddnet
  vitetris
  steam
  lutris
  prismlauncher
  jdk21
  jdk17
  jdk8
  wineWow64Packages.minimal

  # Arts
  aseprite
   #krita

  # Xorg
  i3
  feh
  maim
  xclip
  xsel
  rofi
  rofi-power-menu
  picom
  warpd

  # X.org
  xorg.xorgserver
  xorg.xf86inputevdev
  xorg.xf86inputsynaptics
  xorg.xf86inputlibinput
  xorg.xf86videointel # Intel
  
  # Sound
  alsa-oss
  pavucontrol
  libjack2
  jack2
  qjackctl
  jack_capture
  ];

  # I3 Gaps
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.windowManager.i3.enable = true;
  # Default Shell
  environment.shells = with pkgs; [ zsh ];

  # Doas Enable & Config
  security = {
    doas = {
    enable = true;
  extraConfig = ''
  permit persist keepenv :wheel
  '';
  };
  };

  # ADB
  services.udev.packages = [
    pkgs.android-udev-rules
  ];


  # Sudo Disable
  security.sudo.enable = false; # Sudo Disable

  # Steam
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  };

  # Nix
  nix = {
    settings = {
      trusted-users = [ 
        "username"
        "root"
      ];
      trusted-substituters = [
        "https://nyx.chaotic.cx"
      ];
      extra-trusted-substituters = [
        "https://nyx.chaotic.cx"
      ];
      substituters = [ 
        "https://hyprland.cachix.org"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nyx.chaotic.cx"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      extra-trusted-public-keys = [
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Nixpkgs Rules
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1u"
        "openssl-1.1.1w"
      ];
      overlays = [
        outputs.overlays.default
        inputs.chaotic.overlays.default
        inputs.nurpkgs.overlay
      ];
    };
  };

  # System
  system.stateVersion = "23.05";
}
