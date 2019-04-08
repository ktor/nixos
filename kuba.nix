{ config, pkgs, ... }:
{
  networking = {
    extraHosts =
      ''
      127.0.0.1 kuba.test
      '';
    };
    services.nginx = {
      enable = true;
      virtualHosts."kuba.test" = {
        forceSSL = false;
        root = "/var/www/kuba";
        locations."~ \.php$".extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          index index.php index.html;
          fastcgi_pass 127.0.0.1:9000;
          fastcgi_index index.php;
        '';
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    services.phpfpm.poolConfigs.mypool = ''
      listen = 127.0.0.1:9000
      user = nobody
      pm = dynamic
      pm.max_children = 5
      pm.start_servers = 2
      pm.min_spare_servers = 1
      pm.max_spare_servers = 3
      pm.max_requests = 500
    '';
  }
