{ config, pkgs, inputs, ... }:

let
  defaultLocale = "pt_BR.UTF-8";
  starRailTheme = pkgs.fetchFromGitHub {
    owner = "voidlhf";
    repo = "StarRailGrubThemes";
    rev = "20250927-065308";
    sha256 = "sha256-UfFDYB6VKMF5OPoDSNDhzEoC1EDcpC34C+ebQvjLuvU=";
  };

  gnomeExtensions = with pkgs.gnomeExtensions; [
    dash-to-dock
    blur-my-shell
    user-themes
    just-perfection
    open-bar
    logo-menu
    freon
  ];
in
{
  imports = [];
  system.stateVersion = "25.05";

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      theme = "${starRailTheme}/assets/themes/Evernight";
    };
    efi.canTouchEfiVariables = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;


  time.timeZone = "America/Sao_Paulo";

  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "br";
      variant = "";
    };
  };

  console.keyMap = "br-abnt2";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.matheus = {
    isNormalUser = true;
    description = "matheus";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  home-manager.users.matheus = {
    imports = [ ../../users/matheus/matheus.nix ];
  };

  home-manager.backupFileExtension = "backup";

  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = gnomeExtensions ++ (with pkgs; [
    firefox
    kitty
    fish
    tmux

    neofetch
    fastfetch

    youtube-music

    lm_sensors
    lazydocker
    git
    vscode
    discord
    btop
    tree

    # Para desenvolvimento
    nodejs_22
    terraform
    terraformer
    tfswitch
    nodePackages_latest.ts-node
    awscli2
    python314
    go
    gopls
    go-tools
    delve

    # Para estudos
    obsidian

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    gnome-tweaks

    conky
    gcc

    obs-studio
    vlc

    steam
  ]);

  environment.gnome.excludePackages = with pkgs; [
    geary
    gnome-contacts
    gnome-weather
    gnome-clocks
    gnome-maps
    gnome-music
    totem
    gnome-calendar
    gnome-tour
    epiphany
    yelp
    gnome-connections
    snapshot
    simple-scan
    baobab
    gnome-logs
  ];

  programs = {
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
