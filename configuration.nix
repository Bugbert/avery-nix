# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "avery-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking = {
  #  defaultGateway6 = {
  #    address = "fe80::1";
  #    interface = "eno1";
  #  };
  #  interfaces.eno1 = {
  #    ipv4.addresses = [{
  #      address = "192.168.1.4";
#	prefixLength = 24;
#      }];
#      ipv6.addresses = [{
#        address = "fe80::4";
#        prefixLength = 64;
#      }];
#    };
#  };
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.groups.ubridge.gid = 1005;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.avery = {
    isNormalUser = true;
    description = "Avery";
    extraGroups = [ "networkmanager" "ubridge" "wheel" "wireshark" ];
    packages = with pkgs; [
      alacritty
      bemenu
      btop
      #ciscoPacketTracer8	wait until 8.2.2
      firefox
      gns3-gui
      godot_4
      krita
      libreoffice
      musescore
      #obsidian			broken for now
      prismlauncher
      swww
      thunderbird
      waybar
      wl-clipboard
      zoom-us
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    dynamips
    git
    gns3-server
    greetd.tuigreet
    greetd.greetd
    inetutils
    languagetool
    neovim
    qemu
    ubridge
    unzip
    vim
    vpcs
    wireshark
  ];

  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    times-newer-roman
  ];

  xdg.portal.wlr.enable = true;

  programs = {
    river.enable = true;
    wireshark.enable = true;
  };

  security = {
    wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "ubridge";
      permissions = "u+rx,g+x";
    };
    rtkit.enable = true;
  };

  services = {
    #borgbackup.jobs.avery-home = {
    #  paths = "/home/avery";
    #  encryption.mode = "none";
    #  repo = "/var/backups/avery-home";
    #  compression = "auto,zstd";
    #  startAt = "daily";
    #};

    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -c river";
    };

    languagetool.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    xserver = {
      layout = "us";
      xkbVariant = "";
    };
  };

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
