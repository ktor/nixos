{ config, pkgs, ... }:
let
  my-python3-packages = python38Packages: with python38Packages; [
    pip
    virtualenv
    lxml
    pyyaml
    pygments
  ];
  python3-with-my-packages = pkgs.python3.withPackages my-python3-packages;
  video= with pkgs; [
    losslesscut-bin
    obs-studio # streaming
    breeze-icons
    ffmpeg-full
    frei0r
    blender
    openshot-qt
    vlc
  ];
  photo= with pkgs; [
    darktable
    gimp
    shotwell
  ];
  archiving=with pkgs; [
    ark
    dropbox-cli
    p7zip
    syncthing
    recoll
    unzip
  ];
  security=with pkgs;[
    gnupg
    keepassxc
    keybase
    keybase-gui
    alock
    cacert
    cachix
  ];
  mail=with pkgs;[
    msgviewer
    thunderbird-bin
  ];
  notifications=with pkgs;[
    networkmanagerapplet
    dunst # lightweight notifications
    libnotify # lightweight notifications
    stalonetray
  ];
  desktop= with pkgs; [
    anydesk
    glxinfo # thunderbird needs that for WebGL support
    spotify
    xsel
    xclip
    acpilight
    compton
    dmenu
    j4-dmenu-desktop
    gmrun
    haskellPackages.xmobar
    jmtpfs # mount android phone as block device
    lxmenu-data
    nssmdns
    pavucontrol
    shared-mime-info
    unclutter-xfixes
    feh
    shutter
    xcape
    xorg.xkbcomp
  ];
  gnomeAppsDependencies = with pkgs; [
    gnome3.gnome-keyring
    gnome3.seahorse
    gnome3.dconf
    gnome3.pomodoro
  ];
  development= with pkgs; [
    exercism # A Go based command line tool for exercism.io
    # bcompare - use newer version from nix-env
    # jetbrains.idea-ultimate
    asciidoctor
    charles
    ctags
    gcc
    automake
    autoconf
    python
    python3-with-my-packages
    groovy
    go
    # telnet
    docker_compose
    gitAndTools.gitFull
    git-lfs
  ];
  web= with pkgs;[
    brave
    chromium
    google-chrome
    firefox
    wget
    openssl
    curlFull
  ];
  haskellStuff= with pkgs; [
    stack
    ghc
    cabal2nix
  ];
  frontend= with pkgs; [
    nodePackages.node2nix
    nodejs
    yarn
  ];
  office= with pkgs; [
    ganttproject-bin
    teams
    mime-types
    copyq
    freemind
    calibre
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
  chat=with pkgs; [
    skype
    slack
    discord
    irssi
    signal-desktop
  ];
  cli=with pkgs; [
    exa # alternative replacement for ls
    fd
    dos2unix
    fzf
    htop
    powertop
    jq
    alacritty
    bat
    highlight
    hstr
    ripgrep
    tig
    tmux
    vimHugeX
    tree
    direnv
    nix-direnv
  ];
  network=with pkgs; [
    soapui
    telnet
  ];
  allPackages = archiving
    ++ chat
    ++ cli
    ++ desktop
    ++ development
    ++ fileSystemUtilities
    ++ frontend
    ++ gnomeAppsDependencies
    ++ haskellStuff
    ++ mail
    ++ network
    ++ notifications
    ++ office
    ++ photo
    ++ security
    ++ video
    ++ web;
in {
  environment.systemPackages = with pkgs; [
    fswatch
    file
    acpitool
    graphviz # for plantuml
    libxml2
    lm_sensors
  ] ++ allPackages;

}
