{ config, pkgs, inputs, ... }:

let
  starRailTheme = pkgs.fetchFromGitHub {
    owner = "voidlhf";
    repo = "StarRailGrubThemes";
    rev = "20250927-065308";
    sha256 = "sha256-UfFDYB6VKMF5OPoDSNDhzEoC1EDcpC34C+ebQvjLuvU=";
  };
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
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
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
    imports = [ ./home.nix ];
  };

  home-manager.backupFileExtension = "backup";

  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
    kitty
    fish
    tmux

    neofetch
    fastfetch

    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    gnomeExtensions.just-perfection
    gnomeExtensions.open-bar
    gnomeExtensions.logo-menu
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.freon
    tokyonight-gtk-theme
    papirus-icon-theme

    lm_sensors
    lazydocker
    git
    vscode
    discord
    btop

    # Para desenvolvimento
    nodejs_22
    terraform
    terraformer
    tfswitch
    nodePackages_latest.ts-node
    awscli2
    python314

    # Para estudos
    obsidian
  ];

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
}
