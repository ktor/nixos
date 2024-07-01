{ config, pkgs, ... }:
{
  security = {
    pki.certificateFiles = [
      /home/ktor/.config/certs/cloudflare-inc-ecc-ca-3.crt
      /home/ktor/.config/certs/mitmproxy-ca.crt
      /home/ktor/.config/certs/O2-root-2021-CA.crt
      /home/ktor/.config/certs/O2-root-CA-2022.crt
      /home/ktor/.config/certs/O2-root-CA.crt
      /home/ktor/.config/certs/VSE-root-CA.crt
      /home/ktor/.config/certs/VSE-root-2-CA.crt
    ];
  };
}
