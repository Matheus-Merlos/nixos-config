{ config, pkgs, inputs, ... }: 


let
  gnomeExtensions = with pkgs.gnomeExtensions; [
    dash-to-dock
    blur-my-shell
    user-themes
    just-perfection
    open-bar
    logo-menu
    freon
    show-desktop-button
    coverflow-alt-tab
  ];
  gnomeExtensionIds = map (e: e.extensionUuid) gnomeExtensions;
  hanabiPkg = (pkgs.callPackage ../../pkgs/hanabi.nix { }).hanabi;
  mornyeChibiPng = ./assets/mornye-chibi.png;
in
{
  home.stateVersion = "25.05";

  home.packages = gnomeExtensions ++ (with pkgs; [
    tokyonight-gtk-theme
    catppuccin-gtk
    papirus-icon-theme
    hanabiPkg

    imagemagick
    chafa
  ]);

  xdg.configFile."conky/conky.conf".text = ''
    conky.config = {
        alignment = 'top_left',
        background = false,
        border_width = 1,
        cpu_avg_samples = 2,
        default_color = 'c0caf5',
        default_outline_color = 'white',
        default_shade_color = 'white',
        double_buffer = true,
        draw_borders = false,
        draw_graph_borders = true,
        draw_outline = false,
        draw_shades = false,
        use_xft = true,
        font = 'JetBrainsMono Nerd Font:size=10',
        gap_x = 30,
        gap_y = 50,
        minimum_height = 5,
        minimum_width = 300,
        net_avg_samples = 2,
        no_buffers = true,
        out_to_console = false,
        out_to_ncurses = false,
        out_to_stderr = false,
        out_to_x = true,
        own_window = true,
        own_window_class = 'Conky',
        own_window_type = 'normal',
        own_window_transparent = false,
        own_window_argb_visual = true,
        own_window_argb_value = 150,
        own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
        show_graph_range = false,
        show_graph_scale = false,
        stippled_borders = 0,
        update_interval = 1.0,
        uppercase = false,
        use_spacer = 'none',
        
        color1 = 'ff9e64',
        color2 = '7dcfff',
        color3 = 'bb9af7',
        color4 = 'f7768e',
    }

    conky.text = [[
    ''${color1}''${font JetBrainsMono Nerd Font:weight=Bold:size=50}''${time %H:%M}''${font}
    ''${voffset 10}''${color2}''${font JetBrainsMono Nerd Font:weight=Bold:size=15}''${time %d.%m.%Y %A}''${font}
    ''${voffset 10}
    ''${color2}''${font :weight=Bold}WEATHER''${font} ''${hr 2}
    ''${color}Francisco Beltrão: ''${execi 600 curl -s "wttr.in/Francisco+Beltrao?format=%C+%t"}
    Wind: ''${execi 600 curl -s "wttr.in/Francisco+Beltrao?format=%w"}
    
    ''${voffset 10}''${color2}''${font :weight=Bold}SYSTEM / NET''${font} ''${hr 2}
    ''${color}Host:''${alignr}''${nodename}
    Kernel:''${alignr}''${kernel}
    Uptime:''${alignr}''${uptime}
    
    ''${color2}Interface:''${color} ''${gw_iface}
    ''${color2}IP Local:''${color} ''${addr ''${gw_iface}}
    ''${color2}Up:''${color} ''${upspeed ''${gw_iface}} ''${alignr}''${color2}Down:''${color} ''${downspeed ''${gw_iface}}
    ''${upspeedgraph ''${gw_iface} 30,145 3b4261 7dcfff -t} ''${alignr}''${downspeedgraph ''${gw_iface} 30,145 3b4261 7dcfff -t}

    ''${voffset 10}''${color2}''${font :weight=Bold}CPU (i5-1135G7)''${font} ''${hr 2}
    ''${color}Usage: ''${cpu cpu0}% ''${alignr}Freq: ''${freq_g}GHz
    ''${color3}''${cpubar cpu0 10, 300}
    ''${voffset 5}
    ''${color}Core 1: ''${cpu cpu1}% ''${cpubar cpu1 6, 60}  ''${alignr}Core 2: ''${cpu cpu2}% ''${cpubar cpu2 6, 60}
    Core 3: ''${cpu cpu3}% ''${cpubar cpu3 6, 60}  ''${alignr}Core 4: ''${cpu cpu4}% ''${cpubar cpu4 6, 60}
    Core 5: ''${cpu cpu5}% ''${cpubar cpu5 6, 60}  ''${alignr}Core 6: ''${cpu cpu6}% ''${cpubar cpu6 6, 60}
    Core 7: ''${cpu cpu7}% ''${cpubar cpu7 6, 60}  ''${alignr}Core 8: ''${cpu cpu8}% ''${cpubar cpu8 6, 60}

    ''${voffset 10}''${color2}''${font :weight=Bold}MEMORY / DISK''${font} ''${hr 2}
    ''${color}RAM: ''${mem} / ''${memmax} ''${alignr}''${memperc}%
    ''${color3}''${membar 10, 300}
    
    ''${color}Swap: ''${swap} / ''${swapmax}
    ''${color3}''${swapbar 10, 300}
    
    ''${color}Root: ''${fs_used /} / ''${fs_size /}
    ''${color3}''${fs_bar 10, 300 /}

    ''${voffset 10}''${color2}''${font :weight=Bold}TOP PROCESSES''${font} ''${hr 2}
    ''${color}''${top name 1} ''${alignr}''${top cpu 1}%
    ''${color}''${top name 2} ''${alignr}''${top cpu 2}%
    ''${color}''${top name 3} ''${alignr}''${top cpu 3}%
    ''${color}''${top name 4} ''${alignr}''${top cpu 4}%
    ]]
  '';

  xdg.configFile."autostart/conky.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Conky
    Comment=System Monitor
    # Inicia o Conky como daemon e espera 5 segundos para garantir que o GNOME carregou
    Exec=${pkgs.conky}/bin/conky --daemonize --pause=5
    StartupNotify=false
    Terminal=false
  '';

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

      enabled-extensions = gnomeExtensionIds ++ ["hanabi-extension@jeffshee.github.io"];
    };

    "org/gnome/shell/extensions/openbar" = {
      accent-color = ["0.369" "0.361" "0.392"];
      accent-override = false;
      apply-accent-shell = false;
      apply-all-shell = false;
      apply-flatpak = false;
      apply-gtk = false;
      apply-menu-notif = true;
      apply-menu-shell = true;
      auto-bgalpha = false;
      autofg-bar = false;
      autofg-menu = false;
      autohg-bar = false;
      autohg-menu = false;
      autotheme-dark = "Dark";
      autotheme-font = false;
      autotheme-light = "Light";
      autotheme-refresh = false;
      balpha = 1.0;
      bartype = "Islands";
      bcolor = ["0.855" "0.839" "0.886"];
      bg-change = false;
      bgalpha = 0.0;
      bgalpha-wmax = 1.0;
      bgalpha2 = 0.69999999999999996;
      bgcolor = ["0.180" "0.204" "0.251"];
      bgcolor-wmax = ["0.180" "0.204" "0.251"];
      bgcolor2 = ["0.604" "0.600" "0.588"];
      bgpalette = true;
      border-wmax = false;
      bordertype = "solid";
      bottom-margin = 0.0;
      boxalpha = 0.0;
      boxcolor = ["0.180" "0.204" "0.251"];
      bradius = 50.0;
      buttonbg-wmax = false;
      bwidth = 1.5;
      candy1 = ["0" "0.61" "0.74"];
      candy10 = ["0.09" "0.19" "0.72"];
      candy11 = ["0.75" "0.49" "0.44"];
      candy12 = ["1" "0.92" "0.12"];
      candy13 = ["0.38" "0.63" "0.92"];
      candy14 = ["0.37" "0.36" "0.39"];
      candy15 = ["0.40" "0.23" "0.72"];
      candy16 = ["1" "0.32" "0.32"];
      candy2 = ["1" "0.41" "0.41"];
      candy3 = ["0.63" "0.16" "0.8"];
      candy4 = ["0.94" "0.60" "0.23"];
      candy5 = ["0.03" "0.41" "0.62"];
      candy6 = ["0.56" "0.18" "0.43"];
      candy7 = ["0.95" "0.12" "0.67"];
      candy8 = ["0.18" "0.76" "0.49"];
      candy9 = ["0.93" "0.20" "0.23"];
      candyalpha = 0.98999999999999999;
      candybar = false;
      card-hint = 10;
      color-scheme = "prefer-dark";
      corner-radius = false;
      count1 = 229461;
      count10 = 3620;
      count11 = 208;
      count12 = 190;
      count2 = 223771;
      count3 = 47894;
      count4 = 19334;
      count5 = 10972;
      count6 = 10227;
      count7 = 6723;
      count8 = 5461;
      count9 = 4139;
      cust-margin-wmax = false;
      dark-accent-color = ["0.369" "0.361" "0.392"];
      dark-bcolor = ["0.855" "0.839" "0.886"];
      dark-bgcolor = ["0.180" "0.204" "0.251"];
      dark-bgcolor-wmax = ["0.180" "0.204" "0.251"];
      dark-bgcolor2 = ["0.604" "0.600" "0.588"];
      dark-boxcolor = ["0.180" "0.204" "0.251"];
      dark-candy1 = ["0" "0.61" "0.74"];
      dark-candy10 = ["0.09" "0.19" "0.72"];
      dark-candy11 = ["0.75" "0.49" "0.44"];
      dark-candy12 = ["1" "0.92" "0.12"];
      dark-candy13 = ["0.38" "0.63" "0.92"];
      dark-candy14 = ["0.37" "0.36" "0.39"];
      dark-candy15 = ["0.40" "0.23" "0.72"];
      dark-candy16 = ["1" "0.32" "0.32"];
      dark-candy2 = ["1" "0.41" "0.41"];
      dark-candy3 = ["0.63" "0.16" "0.8"];
      dark-candy4 = ["0.94" "0.60" "0.23"];
      dark-candy5 = ["0.03" "0.41" "0.62"];
      dark-candy6 = ["0.56" "0.18" "0.43"];
      dark-candy7 = ["0.95" "0.12" "0.67"];
      dark-candy8 = ["0.18" "0.76" "0.49"];
      dark-candy9 = ["0.93" "0.20" "0.23"];
      dark-dbgcolor = ["0.125" "0.125" "0.125"];
      dark-fgcolor = ["0.847" "0.871" "0.914"];
      dark-hcolor = ["0.749" "0.380" "0.416"];
      dark-hscd-color = ["0.420" "0.408" "0.443"];
      dark-iscolor = ["0.180" "0.204" "0.251"];
      dark-mbcolor = ["0.847" "0.871" "0.914"];
      dark-mbgcolor = ["0.180" "0.204" "0.251"];
      dark-mfgcolor = ["0.847" "0.871" "0.914"];
      dark-mhcolor = ["0.925" "0.937" "0.957"];
      dark-mscolor = ["0.749" "0.380" "0.416"];
      dark-mshcolor = ["0.180" "0.204" "0.251"];
      dark-palette1 = ["48" "56" "72"];
      dark-palette10 = ["77" "91" "117"];
      dark-palette11 = ["191" "131" "148"];
      dark-palette12 = ["200" "164" "180"];
      dark-palette2 = ["187" "100" "108"];
      dark-palette3 = ["76" "83" "105"];
      dark-palette4 = ["218" "214" "226"];
      dark-palette5 = ["93" "131" "171"];
      dark-palette6 = ["86" "108" "138"];
      dark-palette7 = ["137" "177" "186"];
      dark-palette8 = ["132" "90" "103"];
      dark-palette9 = ["194" "151" "159"];
      dark-shcolor = ["0.000" "0.000" "0.000"];
      dark-smbgcolor = ["0.231" "0.259" "0.322"];
      dark-vw-color = ["0.420" "0.408" "0.443"];
      dark-winbcolor = ["0.420" "0.408" "0.443"];
      dashdock-style = "Default";
      dbgalpha = 0.84999999999999998;
      dbgcolor = ["0.125" "0.125" "0.125"];
      dborder = false;
      dbradius = 14.0;
      default-font = "Sans 12";
      destruct-color = ["0.75" "0.11" "0.16"];
      disize = 48.0;
      dshadow = false;
      fgalpha = 1.0;
      fgcolor = ["0.847" "0.871" "0.914"];
      fitts-widgets = true;
      font = "Montserrat Semi-Bold 11";
      gradient = false;
      gradient-direction = "horizontal";
      gtk-popover = false;
      gtk-shadow = "Default";
      gtk-transparency = 1.0;
      halpha = 1.0;
      handle-border = 0.0;
      hbar-gtk3only = false;
      hcolor = ["0.749" "0.380" "0.416"];
      headerbar-hint = 0;
      heffect = false;
      height = 40.0;
      hpad = 4.0;
      hscd-color = ["0.420" "0.408" "0.443"];
      import-export = true;
      isalpha = 1.0;
      iscolor = ["0.180" "0.204" "0.251"];
      light-accent-color = ["0" "0.75" "0.75"];
      light-bcolor = ["0.749" "0.514" "0.580"];
      light-bgcolor = ["0.808" "0.875" "0.886"];
      light-bgcolor-wmax = ["0.922" "0.922" "0.922"];
      light-bgcolor2 = ["0.871" "0.784" "0.792"];
      light-boxcolor = ["0.808" "0.875" "0.886"];
      light-candy1 = ["0" "0.61" "0.74"];
      light-candy10 = ["0.09" "0.19" "0.72"];
      light-candy11 = ["0.75" "0.49" "0.44"];
      light-candy12 = ["1" "0.92" "0.12"];
      light-candy13 = ["0.38" "0.63" "0.92"];
      light-candy14 = ["0.37" "0.36" "0.39"];
      light-candy15 = ["0.40" "0.23" "0.72"];
      light-candy16 = ["1" "0.32" "0.32"];
      light-candy2 = ["1" "0.41" "0.41"];
      light-candy3 = ["0.63" "0.16" "0.8"];
      light-candy4 = ["0.94" "0.60" "0.23"];
      light-candy5 = ["0.03" "0.41" "0.62"];
      light-candy6 = ["0.56" "0.18" "0.43"];
      light-candy7 = ["0.95" "0.12" "0.67"];
      light-candy8 = ["0.18" "0.76" "0.49"];
      light-candy9 = ["0.93" "0.20" "0.23"];
      light-dbgcolor = ["0.125" "0.125" "0.125"];
      light-fgcolor = ["1.0" "1.0" "1.0"];
      light-hcolor = ["0.188" "0.220" "0.282"];
      light-hscd-color = ["0.412" "0.380" "0.490"];
      light-iscolor = ["0.808" "0.875" "0.886"];
      light-mbcolor = ["0.188" "0.220" "0.282"];
      light-mbgcolor = ["0.910" "0.902" "0.925"];
      light-mfgcolor = ["1.0" "1.0" "1.0"];
      light-mhcolor = ["0.188" "0.220" "0.282"];
      light-mscolor = ["0.412" "0.380" "0.490"];
      light-mshcolor = ["0.000" "0.000" "0.000"];
      light-palette1 = ["48" "56" "72"];
      light-palette10 = ["77" "91" "117"];
      light-palette11 = ["191" "131" "148"];
      light-palette12 = ["200" "164" "180"];
      light-palette2 = ["187" "100" "108"];
      light-palette3 = ["76" "83" "105"];
      light-palette4 = ["218" "214" "226"];
      light-palette5 = ["93" "131" "171"];
      light-palette6 = ["86" "108" "138"];
      light-palette7 = ["137" "177" "186"];
      light-palette8 = ["132" "90" "103"];
      light-palette9 = ["194" "151" "159"];
      light-shcolor = ["0.000" "0.000" "0.000"];
      light-smbgcolor = ["0.871" "0.784" "0.792"];
      light-vw-color = ["0.412" "0.380" "0.490"];
      light-winbcolor = ["0.412" "0.380" "0.490"];
      margin = 0.0;
      margin-wmax = 0.0;
      mbalpha = 0.0;
      mbcolor = ["0.847" "0.871" "0.914"];
      mbg-gradient = false;
      mbgalpha = 1.0;
      mbgcolor = ["0.180" "0.204" "0.251"];
      menu-radius = 35.0;
      menustyle = true;
      mfgalpha = 1.0;
      mfgcolor = ["0.847" "0.871" "0.914"];
      mhalpha = 0.34999999999999998;
      mhcolor = ["0.925" "0.937" "0.957"];
      monitor-height = 1080;
      monitor-width = 1920;
      monitors = "all";
      msalpha = 1.0;
      mscolor = ["0.749" "0.380" "0.416"];
      mshalpha = 0.0;
      mshcolor = ["0.180" "0.204" "0.251"];
      neon = false;
      neon-wmax = false;
      notif-radius = 4.0;
      palette1 = ["48" "56" "72"];
      palette10 = ["77" "91" "117"];
      palette11 = ["191" "131" "148"];
      palette12 = ["200" "164" "180"];
      palette2 = ["187" "100" "108"];
      palette3 = ["76" "83" "105"];
      palette4 = ["218" "214" "226"];
      palette5 = ["93" "131" "171"];
      palette6 = ["86" "108" "138"];
      palette7 = ["137" "177" "186"];
      palette8 = ["132" "90" "103"];
      palette9 = ["194" "151" "159"];
      pause-reload = false;
      position = "Top";
      prominent1 = ["100" "100" "100"];
      prominent2 = ["100" "100" "100"];
      prominent3 = ["100" "100" "100"];
      prominent4 = ["100" "100" "100"];
      prominent5 = ["100" "100" "100"];
      prominent6 = ["100" "100" "100"];
      qtoggle-radius = 50.0;
      radius-bottomleft = true;
      radius-bottomright = true;
      radius-topleft = true;
      radius-topright = true;
      reloadstyle = true;
      removestyle = false;
      sbar-gradient = "none";
      set-bottom-margin = true;
      set-fullscreen = false;
      set-notif-position = false;
      set-notifications = false;
      set-overview = false;
      set-yarutheme = false;
      shadow = false;
      shalpha = 0.14999999999999999;
      shcolor = ["0.000" "0.000" "0.000"];
      sidebar-hint = 10;
      slider-height = 4.0;
      smbgalpha = 0.94999999999999996;
      smbgcolor = ["0.231" "0.259" "0.322"];
      smbgoverride = true;
      success-color = ["0.15" "0.635" "0.41"];
      traffic-light = false;
      trigger-autotheme = false;
      trigger-reload = true;
      view-hint = 0;
      vpad = 1.5;
      vw-color = ["0.420" "0.408" "0.443"];
      warning-color = ["0.96" "0.83" "0.17"];
      width-bottom = true;
      width-left = true;
      width-right = true;
      width-top = true;
      winbalpha = 0.59999999999999998;
      winbcolor = ["0.420" "0.408" "0.443"];
      winbradius = 8.0;
      winbwidth = 1.0;
      window-hint = 0;
      wmax-hbarhint = false;
      wmaxbar = false;
    };
  };

  programs = {
    fish = {
      enable = true;
      shellInit = ''
        set -x fish_greeting ""
      '';
    };

    tmux = {
      enable = true;
      extraConfig = ''
        set-option -g default-shell ${pkgs.fish}/bin/fish

        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -g default-terminal "xterm-256color"
      '';
    };

    git = {
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

    kitty = {
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
        background           = "#080b14";
        foreground           = "#e2e8f0";
        cursor               = "#ffffff";
        selection_background = "#3b82f6";
        color0               = "#141b2d";
        color8               = "#475569";
        color1               = "#ff2f2f";
        color9               = "#ff2f2f";
        color2               = "#549a6f";
        color10              = "#549a6f";
        color3               = "#ccac00";
        color11              = "#ccac00";
        color4               = "#3b82f6";
        color12              = "#60a5fa";
        color5               = "#cc68c8";
        color13              = "#cc68c8";
        color6               = "#5eead4";
        color14              = "#99f6e4";
        color7               = "#000000";
        color15              = "#000000";
        selection_foreground = "#080b14";
      };
    };

    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "${mornyeChibiPng}";
          type = "chafa";
          height = 18;
          padding = {
            top = 2;
            right = 2;
          };
        };

        chafa = {
          graphics = "kitty";
        };

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
            key = " └  ";
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
        ];
      };
    };
  };
}
