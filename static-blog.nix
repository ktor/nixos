{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    # virtualHosts."lukreo.servehttp.com" = {
    #   enableACME = false;
    #   forceSSL = false;
    #   root = "/var/www/lukreo";
    # };
  };
}
