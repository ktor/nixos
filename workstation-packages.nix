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
    steam
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
  developmentUtilities = with pkgs; [
    highlight
    gitAndTools.gitFull
    soapui
    wget
    openssl
    curl
    silver-searcher
    tmux
    vim
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
  ++ developmentUtilities
  ++ javaDevelopment
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
      slack
      terminator
      unzip
      viber
      vlc
    ] ++ allPackages;
}
