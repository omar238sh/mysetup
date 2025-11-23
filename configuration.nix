# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  virtualisation.containers.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "initcall_blacklist=simpledrm_platfrom_driver_init"
    "nvidia.NVreg_EnableGpuFirmware=0"
    "video=HDMI-A-1:2560x1440@60"
  ]; 
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
	enable = true;
	consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

  networking.hostName = "omar"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  };
  
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    libxml2
    libz
    glib
    gtk3
  ];
  
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "ModeValidation" "AllowNonEdidModes, NoMaxPClkCheck, NoVertRefreshCheck, NoHorizSyncCheck"
      Option "metamodes" "2560x1440_60 +0+0"
    '';

    monitorSection = ''
      Modeline "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync
      Option "PreferredMode" "2560x1440_60.00"
    '';
  };

  nixpkgs.config.allowUnfree = true;
  
  hardware.graphics = {
  enable = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
     enable = true;
     pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.omar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    #   tree
    # ];
    shell = pkgs.fish;
  };
  fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
  ];
  programs.hyprland.enable = true;
  services.displayManager.ly.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    networkmanagerapplet
    waybar
    ghostty
    yazi
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # services.envfs.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  fileSystems."/" = {
    options = ["compress=zstd" "noatime"];
  };
  fileSystems."/home/omar" = {
    device = "/dev/disk/by-uuid/a81042a7-d0ef-49e1-bb05-803fca26c181";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" ];
  };

  fileSystems."/mnt/tera" = {
    device = "/dev/disk/by-uuid/583ae00c-135a-4827-bae6-04ae086f6d12";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ];
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

