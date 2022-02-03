{ config, pkgs, ... }:
{
  security = {
    pki.certificateFiles = [ "/home/ktor/.config/certs" ];
  };
}
