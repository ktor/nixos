final: prev: {
  jetbrains = {
    jdk = prev.jetbrains.jdk;
    # Control the version of Intellij ourselves and add the plugin.
    idea-ultimate = prev.jetbrains.idea-ultimate.overrideAttrs (old: rec {
      version = "2022.2.2";
      src = prev.fetchurl {
        url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jbr.tar.gz";
        sha256 = "zBmi7Pyzmf9KxpWikEUN3krXu0sEjgsCLTZr/XWV+4s=";
      };
    });
  };
}
