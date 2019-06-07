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
    acpilight
    lxmenu-data
    shared-mime-info
    ark
    recoll
    jmtpfs
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
    gnome3.gnome-keyring
    gnome3.dconf
  ];
  developmentUtilities = with pkgs; [
    gcc
    automake
    autoconf
    python3
    python37Packages.requests
    go
    gnome3.meld
    # telnet
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
    cabal-install
  ];
  javaDevelopment = with pkgs; [
    gradle
    gradle-completion
    jmeter
  ];
  frontendDevelopment = with pkgs; [
    nodePackages.node2nix
    nodejs
    yarn
  ];
  officeUtilities = with pkgs; [
    aspellDicts.ru
    aspellDicts.pl
    aspellDicts.sk
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
    hstr
    telnet
    ripgrep
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
    alacritty
    unzip
    # viber stopped working
    vlc
  ] ++ allPackages;
}
