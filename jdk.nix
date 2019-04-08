{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    visualvm
    oraclejdk
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    oraclejdk.accept_license = true;
    oraclejdk.pluginSupport = true;
  };

}
