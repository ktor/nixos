{ config, pkgs, ... }:
let
  videoEditingPackages = with pkgs; [
    kdeApplications.kdenlive
    ffmpeg-full
    breeze-icons
    frei0r
  ];
  photoEditingPackages = with pkgs; [
    darktable
    gimp
    shotwell
  ];
  desktopUtilities = with pkgs; [
    gmrun
    thunderbird
    gtypist
    copyq
    stalonetray
    flameshot
    feh
    compton
    xcape
    unclutter-xfixes
    xorg.xbacklight
    xorg.xkbcomp
    xsecurelock
    dmenu
    haskellPackages.xmobar
    dunst
    libnotify
    networkmanagerapplet
    pavucontrol
    gnome3.gnome-session
  ];
  gnomeAppsDependencies = with pkgs; [
    gnome3.dconf
  ];
  haskellDevelopment = with pkgs; [
    haskell.compiler.ghc844
    stack
    stack2nix
  ];
  javaDevelopment = with pkgs; [
    visualvm
    maven
    jdk
    jmeter
  ];
  officeUtilities = with pkgs; [
    hledger
    kdeApplications.okular
    ledger
    libreoffice-fresh
    pandoc
  ];
  fileSystemUtilities = with pkgs; [
    exfat-utils
    fuse_exfat
    ntfs3g
    srm
    udiskie
  ];
  allPackages = videoEditingPackages
  ++ photoEditingPackages
  ++ desktopUtilities
  ++ gnomeAppsDependencies
  ++ javaDevelopment
  ++ haskellDevelopment
  ++ officeUtilities
  ++ fileSystemUtilities;
in
  {
    imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    boot = {
      loader.grub.device = "/dev/sdb";   # (for BIOS systems only)

      # HP Probook 640 G1 networking
      initrd.kernelModules = [ "wl" ];

      kernelModules = [ "kvm-intel" "wl" ];
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    };

    networking = {
      networkmanager.enable = true;
      hostName = "probook";
    };
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.pulseaudio.extraConfig = ''
      load-module module-switch-on-connect
    '';

    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    powerManagement.enable = true;


    fonts.fonts = with pkgs; [
      anonymousPro
      powerline-fonts
      corefonts
    ];

    # Packages
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreeRedistributable = true;
    };
    nix = {
      binaryCaches = ["https://cache.nixos.org/" "https://ktor.cachix.org" ];
      binaryCachePublicKeys = [ "ktor.cachix.org-1:4LkNkLl+ZGXd4DOnch87MaErr+1J+PP7z3rnLxtekus=" ];
      trustedUsers = [ "root" "ktor" ];
    };

    environment.systemPackages = with pkgs; [
      acpitool
      calibre
      chromium
      curl
      dropbox-cli
      firefoxWrapper
      freemind
      gitAndTools.gitFull
      graphviz # for plantuml
      keepass
      libxml2
      lm_sensors
      p7zip
      silver-searcher
      skype
      slack
      soapui
      terminator
      tmux
      unzip
      viber
      vim
      vlc
      wget
    ] ++ allPackages;

    ## SERVICES

    # backlight control on notebook
    programs.light.enable = true;
    services = {
    # backlight control on notebook
      actkbd = {
        enable = true;
        bindings = [
          { keys = [ 224 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -A 10"; }
          { keys = [ 225 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -U 10"; }
        ];
      };

      # activate autorandr on sleep
      autorandr.enable = true;

      # Enable the OpenSSH server.
      # sshd.enable = true;
      locate.enable = true;
      printing.enable = true;
      acpid.enable = true;

      redshift = { # limit blue light after sunset
        enable = true;
        latitude = "48.1";
        longitude = "17.1";
        temperature.day = 6500;
        temperature.night = 3400;
      };

      xserver = {
        enable = true;
        synaptics.enable = true; # touchpad

      # Basic keymap, is used for i18n virtual consoles
      layout = "pl";
      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps"; # ctrl instead of caps lock, ctrl alt backspace -> quit X

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      };


      displayManager.lightdm.enable = true;
      windowManager.default = "xmonad";
      desktopManager.xfce.enable = true;

    };
  };


    # Auto upgrade my system
    system.autoUpgrade.enable = true;

    time.timeZone = "Europe/Bratislava";

    # Select internationalisation properties.
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "pl";
      defaultLocale = "pl_PL.UTF-8";
    };

    # Virtualization + containers
    virtualisation.docker.enable = true;

    # Security
    security.sudo.enable = true;
    security.sudo.extraConfig = ''
      %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/poweroff
      %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/reboot
      %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl suspend
    '';

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.extraUsers.ktor= {
      isNormalUser = true;
      group = "users";
      uid = 1000;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      createHome = true;
      home = "/home/ktor";
      shell = "/run/current-system/sw/bin/bash";
    };

    # shell
    programs.bash.enableCompletion = true;

      # Show git info in bash prompt and display a colorful hostname if using ssh.
      programs.bash.promptInit = ''
        source ${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh
      '';

    ## SYSTEMD

    systemd.user.services."xcape" = {
      enable = true;
      description = "xcape to use CTRL as ESC when pressed alone";
      wantedBy = [ "default.target" ];
      serviceConfig.Type = "forking";
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape";
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "Dunst is a lightweight replacement for the notification-daemons provided by most desktop environments.";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    systemd.user.services."wallpaper" = {
      enable = true;
      description = "download bing picture of a day and set as wallpaper with feh";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "/home/ktor/bin/wallpaper";
    };
    
    systemd.user.services."unclutter" = {
      enable = true;
      description = "hide cursor after X seconds idle";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.unclutter}/bin/unclutter --timeout 1 --jitter=20 --ignore-scrolling";
    };

    systemd.user.services."udiskie" = {
      enable = true;
      description = "handle automounting";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie";
    };

    systemd.user.services."compton" = {
      enable = true;
      description = "window shadows";
      wantedBy = [ "default.target" ];
      path = [ pkgs.compton ];
      serviceConfig.Type = "forking";
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.compton}/bin/compton -b --config /home/ktor/.compton.conf";
    };
  }
