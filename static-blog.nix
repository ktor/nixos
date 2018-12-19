{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."lukreo.servehttp.com" = {
      enableACME = false;
      forceSSL = false;
      root = "/var/www/lukreo";
    };
  };
# Optional: You can configure the email address used with Let's Encrypt.
# This way you get renewal reminders (automated by NixOS) as well as expiration emails.
# security.acme.certs = {
#   "blog.example.com".email = "youremail@address.com";
# };
}
