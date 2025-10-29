{ config, pkgs, inputs, ... }: 


let
  evernightWallpaper = ./assets/gnome-wallpaper.jpg;
in
{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
      gtk-theme = "Tokyonight-Dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Tokyonight-Dark";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "discord.desktop"
        "code.desktop"
      ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${evernightWallpaper}";
      picture-uri-dark = "file://${evernightWallpaper}";
      picture-options = "zoomed";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -x fish_greeting ""
    '';
  };

  programs.kitty = {
    enable = true;
    settings = {
      # QOF
      shell = "tmux new-session -A -s main";
      confirm_os_window_close = 0;
      initial_window_width = 800;
      initial_window_height = 600;
      remember_window_size = "yes";
    
      # Fontes
      font_size = 12.0;

      # Background Transparente
      url_color = "#d65c9d";
      background_opacity = 0.75;
      dynamic_background_opacity = "yes";

      # Cores
      background           = "#000000";
      foreground           = "#afc2c2";
      cursor               = "#ffffff";
      selection_background = "#7cbeff";
      color0               = "#bbcbcc";
      color8               = "#ffffff";
      color1               = "#ff2f2f";
      color9               = "#ff2f2f";
      color2               = "#549a6f";
      color10              = "#549a6f";
      color3               = "#ccac00";
      color11              = "#ccac00";
      color4               = "#0099cc";
      color12              = "#0099cc";
      color5               = "#cc68c8";
      color13              = "#cc68c8";
      color6               = "#79c4cc";
      color14              = "#79c4cc";
      color7               = "#000000";
      color15              = "#000000";
      selection_foreground = "#000000";
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g default-shell ${pkgs.fish}/bin/fish
    '';
  };

  programs.git = {
    enable = true;

    userName = "Matheus-Merlos";
    userEmail = "matheusazrmerlos@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = false;
      core.editor = "code --wait";
      push.autoSetupRemote = true;
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " ➜  ";
      };

      modules = [
        "break"
        "break"
        "break"
        {
          type = "os";
          key = "OS   ";
          keyColor = "36";
        }
        {
          type = "kernel";
          key = " ├  ";
          keyColor = "36";
        }
        {
          type = "packages";
          format = "{} (NixOS)"; 
          key = " ├ 󰏖 ";
          keyColor = "36";
        }
        {
          type = "shell";
          key = " └  ";
          keyColor = "36";
        }
        "break"
        {
          type = "wm";
          key = "WM   ";
          keyColor = "34";
        }
        {
          type = "wmtheme";
          key = " ├ 󰉼 ";
          keyColor = "34";
        }
        {
          type = "icons";
          key = " ├ 󰀻 ";
          keyColor = "34";
        }
        {
          type = "cursor";
          key = " ├  ";
          keyColor = "34";
        }
        {
          type = "terminal";
          key = " ├  ";
          keyColor = "34";
        }
        {
          type = "terminalfont";
          key = " └  ";
          keyColor = "34";
        }
        "break"
        {
          type = "host";
          format = "{5} {1} Type {2}";
          key = "PC   ";
          keyColor = "35";
        }
        {
          type = "cpu";
          format = "{1} ({3}) @ {7} GHz";
          key = " ├  ";
          keyColor = "35";
        }
        {
          type = "gpu";
          format = "{1} {2} @ {12} GHz";
          key = " ├ 󰢮 ";
          keyColor = "35";
        }
        {
          type = "memory";
          key = " ├  ";
          keyColor = "35";
        }
        {
          type = "swap";
          key = " ├ 󰓡 ";
          keyColor = "35";
        }
        {
          type = "disk";
          key = " ├ 󰋊 ";
          keyColor = "35";
        }
        {
          type = "monitor";
          key = " └ 󰋊 ";
          keyColor = "35";
        }
        "break"
        "break"
      ];
    };
  };
}
