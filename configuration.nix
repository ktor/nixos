{ config, pkgs, ... }:
{
  imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./keybase.nix
      ./workstation-packages.nix
      # ./static-blog.nix
    ];

    boot = {
      loader.grub.device = "/dev/sdb";   # (for BIOS systems only)

      # HP Probook 640 G1 networking
      initrd.kernelModules = [ "wl" ];

      kernelModules = [ "kvm-intel" "wl" ];
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
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
          127.0.0.1 www.sk.o2
          127.0.0.1 o2static.sk.o2
          127.0.0.1 local.sk.o2
          127.0.0.1 local.o2static.sk.o2
          127.0.0.1 asistent.sk.o2
          127.0.0.1 local.asistent.sk.o2
          127.0.0.1 eshop.tescomobile.sk.o2

        #DEV prostredie
          10.42.11.13     lxeportdev201 dev.o2.sk
          10.42.192.12    lxeportdev301
          10.42.192.13    lxeportdev302
          10.42.128.141   lxeportdev401
          10.42.128.107   lxeportdev402
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
    };

    ## SERVICES

    # backlight control on notebook
    programs.light.enable = true;
    services = {
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
        default = "none";
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
      extraOptions = "--bip 172.200.0.1/16 --ip-masq=false --iptables=false";
    };

    # Security
    security.sudo.enable = true;
    security.sudo.extraConfig = ''
      %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/poweroff
      %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/reboot
      %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl suspend
    '';
    security.pki.certificates = [
      ''
        O2 Docker hub
        =======
        -----BEGIN CERTIFICATE-----
        MIIE1DCCA7ygAwIBAgIERaIxTTANBgkqhkiG9w0BAQUFADA3MQswCQYDVQQGEwJj
        ejELMAkGA1UEChMCTzIxCzAJBgNVBAsTAkNBMQ4wDAYDVQQLEwVPMiBDWjAeFw0w
        NzAxMDgxMTI2MDhaFw0yNzAxMDgxMTU2MDhaMDcxCzAJBgNVBAYTAmN6MQswCQYD
        VQQKEwJPMjELMAkGA1UECxMCQ0ExDjAMBgNVBAsTBU8yIENaMIIBIjANBgkqhkiG
        9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsRQ4NFl6/o/oA/3OuYh5JHZfiQ4XaNEN0yg0
        wJFbb8MLtSEzBr6ygF0zw8q5xARemqzixEty7L0KDOMm+LQRl/j+8cIBUWH6lbY/
        x6qh8RnDufyxG/HjTswDkzw8zCMvT3LiDUcR6t2olal6JnZxK5DboyCNZYHtvCEp
        frlGim1ZDCJ9Y+MaZVk8/p/7NMgPszLNnU8lk+pfooDM0C4+C4kq5Vmq8BEdR6x6
        XEl6eX26KNkx7PJTbHm0VM2NA37Vv3GBvD5G9hBvcRHgDWtSEYG2jumwJbYW1+su
        d9Mp6MvIZfz6DdPUzxsR/EoT85e0lQm89pNAy3C6EFg5LxOVVQIDAQABo4IB5jCC
        AeIwVAYDVR0gBE0wSzBJBgsrBgEEAet8CgEBAzA6MDgGCCsGAQUFBwIBFixodHRw
        Oi8vY2EuY3oubzIuY29tL3BvbGljeS9PMl9DWl9DUG9saWN5LnBkZjARBglghkgB
        hvhCAQEEBAMCAAcwgc8GA1UdHwSBxzCBxDBOoEygSqRIMEYxCzAJBgNVBAYTAmN6
        MQswCQYDVQQKEwJPMjELMAkGA1UECxMCQ0ExDjAMBgNVBAsTBU8yIENaMQ0wCwYD
        VQQDEwRDUkwxMHKgcKBuhiJodHRwOi8vY2EuY3oubzIuY29tL2NybC9DQS1DUkwu
        Y3JshkhsZGFwOi8vY2EuY3oubzIuY29tL291PU8yJTIwQ1osb3U9Q0Esbz1PMixj
        PWN6P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3QwKwYDVR0QBCQwIoAPMjAwNzAx
        MDgxMTI2MDhagQ8yMDI3MDEwODExNTYwOFowCwYDVR0PBAQDAgEGMB8GA1UdIwQY
        MBaAFG/58s8p7u9TtQ8t0Asy3f5XJz6FMB0GA1UdDgQWBBRv+fLPKe7vU7UPLdAL
        Mt3+Vyc+hTAMBgNVHRMEBTADAQH/MB0GCSqGSIb2fQdBAAQQMA4bCFY3LjE6NC4w
        AwIEkDANBgkqhkiG9w0BAQUFAAOCAQEAZjPOqb94CTOLrZIpafYbi/g3Ksd79n1l
        xOIk7Fu4+0gXAkBEuddUJh68VNG2U7QsfYDRvhWaeDKBUUHObLr+ObddiTAenqOO
        QYkoh1eoGBsFFttLM7YZzOtEgLEALnUGz8eq3TuXKfG04KXBx7M3fbSGWRYRBnBL
        SecVof2FpdHbZ+40lwvo+u4h/Rg6/Fe69sDr5bWC3Z2z7057y+BS65isS3h5urPp
        RPVzC7tOks6LEwntOQvuHd2OcI6Zvxa7sgTTF2Nr+fWt0RQdJ5JKTCKOcC+49HJU
        +dKZMMX/NkFQvMZfALMT7g/Mv5hjI1Xl7z0wCwzjbr65bnL4ncSovQ==
        -----END CERTIFICATE-----
      ''
    ];

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

    systemd.user.services."udiskie" = {
      enable = true;
      description = "handle automounting";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie";
    };

  }
