{ pkgs, inputs, ... }:

{
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = false;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  nix.settings = {
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
}
