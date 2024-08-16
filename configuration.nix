# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let blockedDomains = [ "www.youtube.com" ]; in
let sshPorts = [ 51658 ]; in
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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    rtl-sdr.enable = true;
  };

  networking.hostName = "avery-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };
    dhcpcd.enable = false;
    hosts = {
      "::" = blockedDomains;
      "0.0.0.0" = blockedDomains;
    };
    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.4";
	prefixLength = 24;
      }];
#      ipv6.addresses = [{
#        address = "fe80::4";
#        prefixLength = 64;
#      }];
    };
    nameservers = [ "192.168.1.1" ];
  };

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
    extraGroups = [ "docker" "lp" "networkmanager" "plugdev" "rtlsdr" "ubridge" "video" "wheel" "wireshark" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = rec {
    XDG_BIN_HOME = "$HOME/.local/bin";

    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

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
    librtlsdr
    neovim
    p7zip
    pass
    pv
    python3
    qemu
    rtl-sdr
    swayidle
    ubridge
    uftpd
    unzip
    uucp
    vim
    vpcs
    wireshark
    wlr-randr
    zig_0_12
  ];

  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    times-newer-roman
  ];

  xdg.portal.wlr.enable = true;

  programs = {
    java.enable = true;
    nix-ld.enable = true;
    river.enable = true;
    steam.enable = true;
    wireshark.enable = true;
    zsh.enable = true;
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
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    blueman.enable = true;

    #borgbackup.jobs.avery-home = {
    #  paths = "/home/avery";
    #  encryption.mode = "none";
    #  repo = "/var/backups/avery-home";
    #  compression = "auto,zstd";
    #  startAt = "daily";
    #};

    gitwatch = import ./gitwatchers.nix;

    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -rc river";
    };

    languagetool.enable = true;

    openssh = {
      enable = true;
      ports = sshPorts;
      settings = {
        AllowUsers = [ "avery" ];
	PasswordAuthentication = false;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin ];
    };

    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = sshPorts;
  # networking.firewall.allowedUDPPorts = [ 69 ];
  networking.firewall.interfaces."enp10s0" = {
    allowedTCPPortRanges = [ { from = 0; to = 65535; } ];
    allowedUDPPortRanges = [ { from = 0; to = 65535; } ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
