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
    kodi
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
    keysmith
    gnupg
    keepassxc
    keybase
    keybase-gui
    alock
    xss-lock
    i3lock
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
  gaming= with pkgs; [
    prismlauncher
    minecraft-server
  ];
  desktop= with pkgs; [
    obsidian
    timeular
    clementine
    qcad
    cozy
    anydesk
    glxinfo # thunderbird needs that for WebGL support
    spotify
    xsel
    xclip
    acpilight
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
    dconf
    gnome3.pomodoro
  ];
  development= with pkgs; [
    difftastic
    httpie
    hugo # static website generator
    gh # github cli client
    exercism # A Go based command line tool for exercism.io
    # bcompare # - use newer version from nix-env
    # jetbrains.idea-ultimate
    asciidoctor
    charles
    ctags
    gcc
    automake
    autoconf
    python3-with-my-packages
    groovy
    go
    docker-compose
    gitAndTools.gitFull
    git-imerge # faster merge/rebase option https://softwareswirl.blogspot.com/2013/05/git-imerge-practical-introduction.html
    git-lfs
    nodejs_20 # global access for Intellij IDEA
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
  office= with pkgs; [
    okular # handles pdf attachments
    evince
    ganttproject-bin
    mime-types
    copyq
    freemind
    freeplane # improved freemind
    calibre
    aspellDicts.ru
    aspellDicts.pl
    aspellDicts.sk
    hledger
    hledger-web
    qpdfview
    ledger
    libreoffice-fresh
    pandoc
  ];
  fileSystemUtilities = with pkgs; [
    jdiskreport
    exfat
    ntfs3g
    srm
    udiskie
  ];
  chat=with pkgs; [
    whatsapp-for-linux
    skypeforlinux
    slack
    discord
    irssi
    signal-desktop
    tdesktop
  ];
  cli=with pkgs; [
    eza
    audible-cli
    wakatime
    ghostscript
    imagemagick
    zip
    czkawka # quick search for duplicate files
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
    inetutils # telnet
    kubectl
  ];
  allPackages = archiving
    ++ chat
    ++ cli
    ++ desktop
    ++ gaming
    ++ development
    ++ fileSystemUtilities
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
