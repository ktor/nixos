final: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (selfLinux: superLinux: {
    nvidia_x11 = superLinux.linuxPackages_latest.nvidia_x11.overrideAttrs (s: rec {
      version = "520.56.06";
      name = (builtins.parseDrvName s.name).name + "-" + version;
      src = prev.fetchurl {
        url = "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run";
        sha256 = "06wr3dfmmm4km8mcz56rzlz1r6fbk0n2570wp5g0m155zcxdqgif";
      };
    });
  });
}
