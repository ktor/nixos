{ config, lib, pkgs, options, modulesPath, ... }:
let
  startWebcam = import ./start-webcam.nix;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  pr = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/refs/heads/master.zip)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
  {
    imports = [
      # Include the results of the hardware scan.
      ./probook.nix
      ./keybase.nix
      ./workstation-packages.nix
      ./pki.nix
      ./java.nix
      ./suspend.nix
      ./shell.nix
      ./wine.nix
    ];


    boot = {
      loader.systemd-boot.enable = true; # (for UEFI systems only)

      extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

      kernelModules = [
        "v4l2loopback"
      ];

      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      '';

      kernel.sysctl = {
        "vm.max_map_count" = 262144;
      };

      supportedFilesystems = [ "ntfs" "exfat" ];
    };

    fileSystems."/boot".device = "/dev/disk/by-label/boot";
    fileSystems."/home/ktor/development" = {
      fsType = "ext4";
      device = "/dev/disk/by-label/development";
      options = ["rw" "user" "exec"];
    };

    swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

    networking = {
      networkmanager.enable = true;
      hostName = "probook";

      firewall = {
        allowedTCPPorts = [ 80 443 8081 631 25565 27036 27037 ];
        allowedUDPPorts = [ 631 27031 27036 ];
      };
      extraHosts = (''
          127.0.0.1 mock.sk.o2 www.sk.o2 o2static.sk.o2 local.admin.sk.o2 local.sk.o2 local.o2static.sk.o2 asistent.sk.o2 local.asistent.sk.o2 testeshop.tescomobile.sk.o2 npm.lukreo.com local.lukreo.com my.local.lukreo.com local.lukreo.pl moje.local.lukreo.pl local.com.liferay local.portal.vse.sk local.threat.sk.o2security local.botnet.sk.o2security local.filter.sk.o2security local.test.filter.com local.test.botnet.com local.test.threat.com
      '');

         # ${
         #   let
         #     hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
         #     hostsFile = builtins.fetchurl hostsPath;
         #   in builtins.readFile "${hostsFile}"
         # }
         nameservers = ["1.1.1.1" "1.0.0.1"];
         search = ["to2.to2cz.cz" "ux.to2sk.sk" "ux.to2cz.cz"];
       };

       hardware.pulseaudio = {
         enable = true;
         package = pkgs.pulseaudioFull;
         support32Bit = true;
         extraConfig = ''
              load-module module-switch-on-connect
         '';
         extraModules = [ ];
       };

       hardware.bluetooth = {
         enable = true;
         package = pkgs.bluez;
       };

       hardware.opengl = {
         enable=true;
         extraPackages = with pkgs; [
           vaapiIntel
           vaapiVdpau
           libvdpau-va-gl
         ];
         driSupport = true;
         driSupport32Bit = true;
       };

       environment = {
        variables.JAVAX_NET_SSL_TRUSTSTORE =
          let
            caBundle = config.environment.etc."ssl/certs/ca-certificates.crt".source;
            p11kit = pkgs.p11-kit.overrideAttrs (oldAttrs: {
              configureFlags = [
                "--with-trust-paths=${caBundle}"
              ];
            });
          in derivation {
            name = "java-cacerts";
            builder = pkgs.writeShellScript "java-cacerts-builder" ''
              ${p11kit.bin}/bin/trust \
                extract \
                --format=java-cacerts \
                --purpose=server-auth \
                $out
            '';
            system = builtins.currentSystem;
          };
         systemPackages = [
           nvidia-offload
           (pr.jetbrains.plugins.addPlugins pr.jetbrains.idea-ultimate [ "github-copilot" ])
           pkgs.ffmpeg
           pkgs.gphoto2
           pkgs.mpv
         ];
         pathsToLink = [
           "/share/nix-direnv"
         ];
         etc = with pkgs; {
           "jdk".source = jdk;
           "jdk8".source = adoptopenjdk-hotspot-bin-8;
           "jdk11".source = jdk11;
           "jdk17".source = jdk17;
           "groovy".source = groovy;
         };
       };

       hardware.nvidia.modesetting.enable = true;
       hardware.nvidia.prime = {
        # sync.enable = true;

        offload.enable = true;

        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";

        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";
      };

      hardware.cpu.intel.updateMicrocode = true;

      powerManagement = {
        enable = true;
      };


      fonts.packages = with pkgs; [
        nerdfonts # very nice coding fonts with icon/powerline support
        corefonts
        lato # nice presentation font
      ];

    # Packages
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreeRedistributable = true;
        allowBroken = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
          "qtwebkit-5.212.0-alpha4"
          "nodejs-14.21.3"
          "openssl-1.1.1u"
          "openssl-1.1.1v"
        ];
      };
      overlays = (import ./overlays); # ++ [ jetbrains-updater.overlay ];
    };

    nix = {
      settings = {
        sandbox = true;
        trusted-users = [ "root" "ktor" ];
        auto-optimise-store = true;
        max-jobs = lib.mkDefault 8;
        experimental-features = [ "nix-command" "flakes" ];
      };
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    };

    ## SERVICES


    location = {
      provider = "manual";
      latitude = 48.14;
      longitude = 17.10;
    };


    services = {

      thermald.enable = true;

      auto-cpufreq.enable = true;

      auto-cpufreq.settings = {
        battery = {
           governor = "powersave";
           turbo = "never";
        };
        charger = {
           governor = "performance";
           turbo = "auto";
        };
      };

      udev.extraRules = ''
          ACTION=="add",  \
          SUBSYSTEM=="usb", \
          ATTR{idVendor}=="04b0", \
          ATTR{idProduct}=="0433",  \
          RUN+="${startWebcam}/bin/start-webcam"
      '';

      gvfs.enable = true;

      ntp.enable = true;

      fprintd.enable = true; # fingerprint support

      cron.enable = true;

      blueman.enable = true;

      fstrim.enable = true;

      flatpak.enable = true;
      batteryNotifier.enable = true; # see suspend.nix

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

      # visual sugar
      picom = {
        enable          = true;
        fade            = true;
        inactiveOpacity = 0.9;
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
        pkgs.cnijfilter2
        pkgs.canon-cups-ufr2
      ];

      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      # Enable the OpenSSH server.
      # sshd.enable = true;
      locate.enable = true;
      acpid.enable = true;

      redshift = { # limit blue light after sunset
        enable = true;
        temperature.day = 6500;
        temperature.night = 2700;
        brightness.night = "0.8";
      };

    displayManager = {
      defaultSession = "none+xmonad";
    };
      
    xserver = {
      enable = true;
      # synaptics.enable = true; # touchpad

      videoDrivers = [ "nvidia" ];

      # Basic keymap, is used for i18n virtual consoles
      xkb = {
        options = "terminate:ctrl_alt_bksp, ctrl:nocaps"; # ctrl instead of caps lock, ctrl alt backspace -> quit X
        layout = "pl";
      };

      displayManager = {
        lightdm.enable = true;
      };

      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      };
    };
    gnome.gnome-keyring.enable = true;
    dbus.packages = with pkgs; [ dconf ];
  };


  xdg.portal.enable = true;

  # Auto upgrade my system
  system.autoUpgrade.enable = false;
  system.stateVersion = "22.05";

  time = {
    timeZone = "Europe/Bratislava";
    hardwareClockInLocalTime = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Virtualization + containers
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      extraOptions = "--bip 172.200.0.1/16 --ip-masq=true --iptables=true --insecure-registry docker.devlab.sk.o2";
    };
  };

  # Security
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    pam = {
      services.lightdm.enableGnomeKeyring = true; # unlock gnome keyring upon login with lightdm
      services.lightdm.enableKwallet = true; # unlock gnome keyring upon login with lightdm
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
    extraGroups = [ "autologin" "wheel" "networkmanager" "docker" "video" "lp" ];
    createHome = true;
    home = "/home/ktor";
    shell = "/run/current-system/sw/bin/bash";
  };

  programs = {
    virt-manager.enable = true;

    # backlight control on notebook
    light.enable = true;

    # shell
    bash = {
      enableCompletion = true;

      # Show git info in bash prompt and display a colorful hostname if using ssh.
      promptInit = ''
        source ${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh
      '';
    };

    dconf.enable = true;

    gnupg.agent.enable = true;

    steam.enable = true;

    nix-ld.enable = true;
  };

  ## SYSTEMD

  systemd.user.services."udiskie" = {
    enable = true;
    description = "handle automounting";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie";
  };

  systemd.services.webcam = {
    enable = true;
    script = ''
      ${pkgs.gphoto2}/bin/gphoto2 --stdout --capture-movie |
        ${pkgs.ffmpeg}/bin/ffmpeg -i - \
            -vcodec rawvideo -pix_fmt yuv420p -f v4l2  /dev/video0
    '';
  };

}
