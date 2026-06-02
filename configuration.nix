


{ config, lib, pkgs,inputs , system ,... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";
  documentation = {
    enable = false;
    man.enable = false;
    doc.enable = false;
    info.enable = false;
    dev.enable = false;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "initcall_blacklist=simpledrm_platform_driver_init"
      "nvidia.NVreg_EnableGpuFirmware=0"
      "video=HDMI-A-1:2560x1440@60"
    ];
    initrd.kernelModules = [ ];

    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "omar" ];
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  networking = {
    hostName = "omar";
    networkmanager.enable = true;
  };

  time.timeZone = "Africa/Cairo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  users.users.omar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };


  environment.systemPackages = with pkgs; [
    coreutils
    util-linux
    findutils
    gnugrep
    gnused
    curl
    htop
    helix
    git
    yazi
    ghostty
    wget
    networkmanagerapplet
  ];

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        hms = "home-manager switch --flake ~/.config/nixos#omar";
        hmu = "nix flake update --flake ~/.config/nixos && home-manager switch --flake ~/.config/nixos#omar";
        rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#omar";
      };
    };
    hyprland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];


  services = {
    openssh.enable = true;
    dbus.enable = true;
    displayManager.ly.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
   xserver.videoDrivers = ["nvidia"];
   gnome.gnome-keyring.enable = true;
  };
  security.pam.services.login.enableGnomeKeyring = true;

  fileSystems."/" = {
    options = [ "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag" "discard=async"];
  };


  fileSystems."/mnt/tera" = {
      device = "/dev/disk/by-uuid/583ae00c-135a-4827-bae6-04ae086f6d12";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "nofail" ];
  };
}
