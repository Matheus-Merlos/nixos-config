{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    theme = ./assets/grub-theme;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nixpkgs.config.allowUnfree = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
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

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  console.keyMap = "br-abnt2";

  services.printing.enable = true;

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
    packages = with pkgs; [];
  };
  home-manager.users.matheus = {
    imports = [ ./home.nix ];
  };

  home-manager.backupFileExtension = "backup";

  programs.firefox.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
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

  system.stateVersion = "25.05";
}
