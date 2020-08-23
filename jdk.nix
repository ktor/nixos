{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    visualvm
    jdk
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    # oraclejdk.accept_license = true;
    # oraclejdk.pluginSupport = true;
  };

}
