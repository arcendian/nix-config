# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the grub boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking = {
    hostName = "nixpc";
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    interfaces = {
      enp1s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
     enable = true;
     # autorun = false;

     # Configure keymap in X11
     layout = "us";
     xkbOptions = "eurosign:e";

     displayManager = {
       defaultSession = "none+bspwm";
       startx.enable = true;
     };

     windowManager.bspwm.enable = true;
     desktopManager.xterm.enable = false;

     # enable touchpad support
     libinput = {
       enable = true;
     }; 

     # intel graphics
     videoDrivers = [ "modesetting" ];
     useGlamor = true;

     # videoDrivers = [ "intel" ];
     # deviceSection = ''
     #   Option "DRI" "2"
     #   Option "TearFree" "true"
     # '';
  };

  # List services that you want to enable:
  services = {
    # enable compositor
    picom = {
      enable = true;
      fade = true;
      inactiveOpacity = 0.9;
      shadow = true;
      fadeDelta = 4;
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable mounting mtp devices via file managers
    # that support gvfs
    gvfs.enable = true;
  };

  # hardware configs
  # Enable sound.
  sound.enable = true;

  # nixpkgs.config.packageOverrides = pkgs: {
  #   vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  # };
  nixpkgs.config.pulseaudio = true;

  hardware = {
    opengl = {
      enable = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-compute-runtime
        # vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        # vaapiVdpau
        # libvdpau-va-gl
      ];
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # text editors
    vim 
    emacs

    # terminal stuff
    pciutils
    git
    curl
    wget
    alacritty
    ripgrep
    bat
    fd
    exa
    fzf
    neofetch
    starship
    htop
    vifm
    youtube-dl
    tmux

    # gui stuff
    brave
    pcmanfm
    feh
    sxiv
    zathura
    flameshot
    lxappearance

    # audio/video
    mpv
    mpd
    ncmpcpp

    # themes
    # gtk themes
    juno-theme
    arc-theme
    ant-theme
    
    # icon themes
    tela-icon-theme
    maia-icon-theme
    numix-icon-theme

    # cursor themes
    numix-cursor-theme
    capitaine-cursors 

    # window manager stuff
    # dmenu	
    rofi
    feh
    polybar

    # hardware stuff
    brightnessctl
    thermald
    alsa-firmware
    sof-firmware
    alsa-ucm-conf

    # intel stuff (don't know what I'm doing here hahaha)
    intel-compute-runtime
    intel-media-driver
    microcodeIntel

    # others
    nixfmt
  ];

  fonts.fonts = with pkgs; [
    # mplus-outline-fonts
    # dina-font
    # proggyfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    jetbrains-mono
    ubuntu_font_family

    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

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
  system.stateVersion = "21.11"; # Did you read the comment?
}

