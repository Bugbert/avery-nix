{ config, pkgs, ... }:

let bemenuOpts = "-ib --hp 8 --fn \"JetBrainsMono Nerd Font\""; in
let uName = "avery"; in
let homeDir = "/home/${uName}"; in
let pinentryPkg = pkgs.pinentry-bemenu; in

let nvimPlugs = with pkgs.vimPlugins; [
  nvim-treesitter
  wrapping-nvim
  {
    plugin = vimwiki;
    config = "let g:vimwiki_list = " + 
	     "[{'path': '~/git/school/', 'syntax': 'markdown', 'ext': 'md'}]";
  }
]; in

let tsLangs = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  markdown
]; in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = uName;
  home.homeDirectory = homeDir;

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
    godot_4
    grim
    gqrx
    hugo
    krita
    libreoffice
    linuxsampler
    mpv
    musescore
    nanotts
    octaveFull
    pamixer
    pinentryPkg
    prismlauncher
    qbittorrent
    qsampler
    r2modman
    reaper
    slurp
    swww
    tenacity
    thunderbird
    ventoy
    waybar
    wayvnc
    wev
#    wineWowPackages.staging
    wineWowPackages.waylandFull
    winetricks
    wl-clipboard
    zettlr
    zoom-us
  ];

  programs = {
    git = {
      enable = true;
      userName = "Avery Andrews";
      userEmail = "avery.andrews@mailfence.com";
      extraConfig.init.defaultBranch = "main"; 
    };

    gpg = {
      enable = true;
    };

    home-manager.enable = true;

    neovim = {
      enable = true;
      plugins = nvimPlugs ++ tsLangs;
    };

    rbw.settings = {
      pinentry = pinentryPkg;
    };

    zsh = {
      enable = true;
      sessionVariables = {
      };
      shellAliases = {
        rb = "sudo nixos-rebuild switch --flake .";
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pinentryPkg;
    };
  };

  systemd.user = {
    sessionVariables = {
      TEST = "test";
      BEMENU_OPTS = bemenuOpts;
    };
  };

  wayland.windowManager.river = {
    enable = true;
    extraConfig = builtins.readFile ./river/init;
    settings = {
      map.normal = {
        "Super Tab" = "spawn 'zsh -c \"bemenu-run ${bemenuOpts} -p run\"'";
	"Super P" = "spawn 'pass -c $(ls ~/.password-store | sed -E \"s/^(.*?)\\.gpg.*/\\1/\" | " +
	            "bemenu ${bemenuOpts} -p account) || true | bemenu ${bemenuOpts} -p Failure'";
      };
    };
    systemd.enable = true;
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

