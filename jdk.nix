{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    visualvm
    graalvm8
    jdk
    jdk11
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    # oraclejdk.accept_license = true;
    # oraclejdk.pluginSupport = true;
  };

}
