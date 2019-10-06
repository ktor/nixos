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
  video= with pkgs; [
    unstable.breeze-icons
    unstable.ffmpeg-full
    unstable.frei0r
    unstable.openshot-qt
    unstable.vlc
  ];
  photo= with pkgs; [
    unstable.darktable
    unstable.gimp
    unstable.shotwell
  ];
  archiving=with pkgs; [
    unstable.ark
    unstable.dropbox-cli
    unstable.p7zip
    unstable.syncthing
    unstable.recoll
    unstable.unzip
  ];
  security=with pkgs;[
    unstable.libsecret
    unstable.gnupg
    unstable.keepass
    unstable.keybase
    unstable.keybase-gui
    unstable.xdotool # for keepass autotype
    unstable.xsecurelock
  ];
  mail=with pkgs;[
    unstable.msgviewer
    unstable.thunderbird
    unstable.gnome3.evolution
  ];
  notifications=with pkgs;[
    networkmanagerapplet
    unstable.dunst # lightweight notifications
    unstable.libnotify # lightweight notifications
    unstable.stalonetray
  ];
  desktop= with pkgs; [
    acpilight
    compton
    dmenu
    gmrun
    haskellPackages.xmobar
    jmtpfs # mount android phone as block device
    lxmenu-data
    nssmdns
    pavucontrol
    unstable.qt4
    shared-mime-info
    unclutter-xfixes
    unstable.feh
    unstable.shutter
    xcape
    xorg.xkbcomp
  ];
  gnomeAppsDependencies = with pkgs; [
    unstable.gnome3.gnome-keyring
    unstable.gnome3.seahorse
    unstable.gnome3.dconf
  ];
  development= with pkgs; [
    unstable.bcompare
    unstable.jetbrains.idea-ultimate
    unstable.asciidoctor
    unstable.mitmproxy
    unstable.ctags
    gcc
    automake
    autoconf
    python
    python3-with-my-packages
    go
    # telnet
    docker_compose
    gitAndTools.gitFull
  ];
  web= with pkgs;[
    unstable.chromium
    unstable.google-chrome
    unstable.wget
    unstable.openssl
    unstable.curl
  ];
  haskellStuff= with pkgs; [
    haskell.compiler.ghc844
    stack
    stack2nix
    cabal-install
  ];
  java= with pkgs; [
    unstable.gradle
    unstable.gradle-completion
    unstable.jmeter
  ];
  frontend= with pkgs; [
    nodePackages.node2nix
    nodejs
    yarn
  ];
  office= with pkgs; [
    copyq
    unstable.freemind
    unstable.calibre
    unstable.aspellDicts.ru
    unstable.aspellDicts.pl
    unstable.aspellDicts.sk
    unstable.hledger
    unstable.qpdfview
    unstable.ledger
    unstable.libreoffice-fresh
    unstable.pandoc
  ];
  fileSystemUtilities = with pkgs; [
    exfat-utils
    fuse_exfat
    ntfs3g
    srm
    udiskie
  ];
  chat=with pkgs; [
    unstable.skype
    unstable.slack
    unstable.irssi
  ];
  cli=with pkgs; [
    unstable.alacritty
    unstable.bat
    unstable.highlight
    unstable.hstr
    unstable.ripgrep
    unstable.tig
    unstable.tmux
    unstable.vimHugeX
  ];
  network=with pkgs; [
    unstable.soapui
    unstable.telnet
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
    ++ java
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
    powertop
    graphviz # for plantuml
    libxml2
    lm_sensors
  ] ++ allPackages;
}
