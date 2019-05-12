{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    visualvm
    # oraclejdk
    jdk
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    # oraclejdk.accept_license = true;
    # oraclejdk.pluginSupport = true;
  };

}
