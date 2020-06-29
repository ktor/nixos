{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    visualvm
    graalvm8
    jdk11
    jdk
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    # oraclejdk.accept_license = true;
    # oraclejdk.pluginSupport = true;
  };

}
