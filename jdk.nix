{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    visualvm
    adoptopenjdk-hotspot-bin-8
    jdk11
    maven
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    # oraclejdk.accept_license = true;
    # oraclejdk.pluginSupport = true;
  };

}
