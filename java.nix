{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    adoptopenjdk-hotspot-bin-8
    jdk11
    jmeter
    visualvm
    maven
    gradle
    gradle-completion
    lombok
    (with eclipses; eclipseWithPlugins {
      eclipse = eclipse-java;
      jvmArgs = [ "-javaagent:${pkgs.lombok.out}/share/java/lombok.jar" ];
      plugins = with plugins; [
        vrapper
        color-theme
      ];
    })
  ];

  environment.etc = with pkgs; {
    "jdk".source = jdk;
    "jdk8".source = adoptopenjdk-hotspot-bin-8;
    "jdk11".source = jdk11;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    # oraclejdk.accept_license = true;
    # oraclejdk.pluginSupport = true;
  };

}
