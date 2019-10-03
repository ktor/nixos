{ config, pkgs, ... }:
let
  unstable = import <unstable> {
    config = config.nixpkgs.config;
  };
  my-python3-packages = python37Packages: with python37Packages; [
    pip
    virtualenv
    lxml
    pyyaml
  ];
  python3-with-my-packages = pkgs.python3.withPackages my-python3-packages;
  videoEditingPackages = with pkgs; [
    openshot-qt
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
    jmtpfs # mount android phone as block device
    nssmdns
    qt4
    syncthing
    keybase
    keybase-gui
    # steam
    gmrun
    thunderbird
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
    dunst # lightweight notifications
    libnotify # lightweight notifications
    networkmanagerapplet
    pavucontrol
  ];
  gnomeAppsDependencies = with pkgs; [
    gnome3.gnome-keyring
    gnome3.dconf
  ];
  developmentUtilities = with pkgs; [
    asciidoctor
    tig
    mitmproxy
    ctags
    gcc
    automake
    autoconf
    python
    python3-with-my-packages
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
    msgviewer
    aspellDicts.ru
    aspellDicts.pl
    aspellDicts.sk
    hledger
    qpdfview
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
    fswatch
    bat
    alacritty
    hstr
    telnet
    ripgrep
    gnupg
    file
    acpitool
    powertop
    calibre
    chromium
    google-chrome
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
    # viber stopped working
    vlc
    unstable.jetbrains.idea-ultimate
  ] ++ allPackages;
}
