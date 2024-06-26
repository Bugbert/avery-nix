{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "avery";
  home.homeDirectory = "/home/avery";

  home.packages = with pkgs; [
    alacritty
    aseprite
    asunder
    bemenu
    blender
    bluetuith
    btop
    dolphin-emu
    firefox
    gns3-gui
    godot_4
    grim
    krita
    libreoffice
    mpv
    musescore
    nanotts
    octaveFull
    pamixer
    prismlauncher
    qbittorrent
    slurp
    swww
    tenacity
    thunderbird
    waybar
    wayvnc
    wev
    wl-clipboard
    zoom-us
  ];

  programs = {
    git = {
      enable = true;
      userName = "Avery Andrews";
      userEmail = "avery.andrews@mailfence.com";
      extraConfig.init.defaultBranch = "main"; 
    };

    home-manager.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}

