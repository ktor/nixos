{ config, pkgs, ... }:
{
  imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./keybase.nix
      ./workstation-packages.nix
      ./jdk.nix
      ./pki.nix
      ./suspend.nix
    ];

    boot = {
      loader.systemd-boot.enable = true; # (for UEFI systems only)
      kernel.sysctl =
        {
          "vm.max_map_count" = 262144;
        };
      };

      swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

      networking = {
        networkmanager.enable = true;
        hostName = "probook";

        firewall = {
          allowedTCPPorts = [ 80 443 631 ];
          allowedUDPPorts = [ 631 ];
        };
        extraHosts =
          ''
            127.0.0.1 lukreo.pl
            127.0.0.1 www.lukreo.pl
            127.0.0.1 moje.lukreo.pl
            127.0.0.1 www.sk.o2
            127.0.0.1 o2static.sk.o2
            127.0.0.1 local.sk.o2
            127.0.0.1 local.o2static.sk.o2
            127.0.0.1 asistent.sk.o2
            127.0.0.1 local.asistent.sk.o2
            127.0.0.1 eshop.tescomobile.sk.o2
          '';
        };

        hardware.pulseaudio.enable = true;
        hardware.pulseaudio.package = pkgs.pulseaudioFull;
        hardware.pulseaudio.support32Bit = true;
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
      useSandbox = true;
    };

    ## SERVICES

    # backlight control on notebook
    programs.light.enable = true;

    services = {
      batteryNotifier.enable = true; # see suspend.nix
      localtime.enable = true;
      syncthing = {
        enable = true;
        dataDir = "/home/ktor/.config/syncthing";
        user = "ktor";
      };

      # use 256 color terminal and true type fonts in console mode
      kmscon.enable = true;
      kmscon.extraConfig = ''font-name=Anonymice Powerline'';

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

      gnome3.tracker.enable = true;

      # visual sugar
      compton = {
        enable          = true;
        fade            = true;
        inactiveOpacity = "0.9";
        shadow          = true;
        fadeDelta       = 4;
      };

      # printing
      printing.enable = true;
      printing.browsing = true;
      printing.defaultShared = true;
      printing.drivers = [
        pkgs.gutenprint
        pkgs.gutenprintBin
        pkgs.hplip
      ];

      avahi.enable = true;
      avahi.publish.enable = true;
      avahi.publish.userServices = true;


      # Enable the OpenSSH server.
      # sshd.enable = true;
      locate.enable = true;
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
      desktopManager = {
        xterm.enable = false;
        gnome3.enable = false;
        lxqt.enable = true;
        default = "lxqt";
      };

    };
  };


    # Auto upgrade my system
    system.autoUpgrade.enable = true;

    time.timeZone = "Europe/Bratislava";

    # Select internationalisation properties.
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "pl";
      defaultLocale = "en_GB.UTF-8";
    };

    # Virtualization + containers
    virtualisation.docker = {
      enable = true;
      extraOptions = "--bip 172.200.0.1/16 --ip-masq=true --iptables=true";
    };

    # Security
    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
      pam = {
        services.lightdm.enableGnomeKeyring = true; # unlock gnome keyring upon login with lightdm
        loginLimits =[
          { domain = "*"; item = "nofile"; type = "-"; value = "999999"; }
        ];
      };
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.extraUsers.ktor= {
      isNormalUser = true;
      group = "users";
      uid = 1000;
      extraGroups = [ "wheel" "networkmanager" "docker" "video" ];
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

    systemd.user.services."udiskie" = {
      enable = true;
      description = "handle automounting";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie";
    };

  }
