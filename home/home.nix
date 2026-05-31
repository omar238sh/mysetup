{ pkgs,inputs ,... }:

{
  home.username = "omar";
  home.homeDirectory = "/home/omar";

  #  catppuccin = {
  #    enable = true;
  #    flavor = "mocha";
  #    accent = "lavender";
  #    pointers.enable = true;
  #  };

  home.packages = with pkgs; [
    hyprshot
    fastfetch
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    zed-editor
    devenv
    nixd
  ];

  programs.starship = {
    enable = true;
    presets = [ "catppuccin-powerline" ];
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  programs.fish = {
    enable = true;


    functions = {

      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };

    shellInit = ''
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.local/share/soar/bin
     '';

    interactiveShellInit = ''
      set -g fish_greeting ""

    '';
  };
  gtk = {
    enable = true;
    theme = {
      name = "adwita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = null;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Omar";
      user.email = "omar238sh@gmail.com";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
