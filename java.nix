{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
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

}
