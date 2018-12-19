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
    nssmdns
    qt4
    syncthing
    keybase
    keybase-gui
    # steam
    gmrun
    thunderbird
    gtypist
    copyq
    stalonetray
    # flameshot version 5.11.1 doesn't work
    shutter
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
  ];
  gnomeAppsDependencies = with pkgs; [
    gnome3.gnome-control-center
    gnome3.gnome-documents
    gnome3.gnome-documents
    gnome3.gnome-photos
    gnome3.gnome-music
    gnome3.nautilus
    gnome3.dconf
  ];
  developmentUtilities = with pkgs; [
    gnome3.meld
    telnet
    docker_compose
    highlight
    gitAndTools.gitFull
    soapui
    wget
    openssl
    curl
    silver-searcher
    tmux
    vimHugeX
  ];
  haskellDevelopment = with pkgs; [
    haskell.compiler.ghc844
    stack
    stack2nix
  ];
  javaDevelopment = with pkgs; [
    gradle
    gradle-completion
    visualvm
    oraclejdk
    jmeter
  ];
  frontendDevelopment = with pkgs; [
    nodePackages.node2nix
    nodejs
    yarn
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
  ++ developmentUtilities
  ++ javaDevelopment
  ++ frontendDevelopment 
  ++ haskellDevelopment
  ++ officeUtilities
  ++ fileSystemUtilities;
in {
  environment.systemPackages = with pkgs; [
    gnupg
    file
    acpitool
    powertop
    calibre
    chromium
    dropbox-cli
    firefoxWrapper
    freemind
    graphviz # for plantuml
    keepass
    xdotool # for keepass autotype
    libxml2
    lm_sensors
    p7zip
    skype
    irssi
    slack
    terminator
    unzip
    viber
    vlc
  ] ++ allPackages;
}
