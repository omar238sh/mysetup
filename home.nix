{ config, pkgs, ... }:

{
    
  home.username = "omar";
  home.homeDirectory = "/home/omar";  
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; 
  };

  home.packages = with pkgs; [
    firefox
    git
    fastfetch
    zig
    # gcc
    bun
    rustup
    hyprsunset
    hyprpaper
    wofi
    nodejs_22
    unzip
    ripgrep
    fd
    gnumake
    cmake
    glibc.dev 
    clang
    android-studio
    blender
    uv
    hyprshot
  ];
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "Omar";
      user.email = "omar238sh@gmail.com";
      };
  };
  

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
  
  programs.fish = {
    enable = true;

    shellAliases = {
      l = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };
    
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

    interactiveShellInit = ''
      set -g fish_greeting ""
      
    '';
  };  

  programs.yazi = {
    enable = true;
    enableFishIntegration = true; 
    settings = {
      mgr = { 
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };  

  xdg.configFile = {
    "nvim" = {
      source = ./nvim;
      recursive = true;
    };
    
    
    "hypr" = {
      source = ./hypr;
      recursive = true;
    };

    
    "waybar" = {
      source = ./waybar;
      recursive = true;
    };

    "wofi" = {
      source = ./wofi;
      recursive = true;
    };
  };

  home.sessionPath = [ "$HOME/.cargo/bin" ];
  home.stateVersion = "25.05"; 
  programs.home-manager.enable = true;
}

