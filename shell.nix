{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (pkgs.buildFHSUserEnv {
      name = "jdk17";
      targetPkgs = pkgs: (with pkgs; [  maven17 gradle jdk17 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
      multiPkgs = pkgs: (with pkgs; [ ]);
      runScript = ''
        env SHELL_NAME="jdk17" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
      '';
    })
    (pkgs.buildFHSUserEnv {
      name = "jdk11";
      targetPkgs = pkgs: (with pkgs; [ p11-kit maven11 gradle jdk11 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
      multiPkgs = pkgs: (with pkgs; [ ]);
      runScript = ''
        env SHELL_NAME="jdk11" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
      '';
    })
    (pkgs.buildFHSUserEnv {
      name = "node18";
      targetPkgs = pkgs: (with pkgs; [ gradle adoptopenjdk-hotspot-bin-8 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv nodejs_18 ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
      multiPkgs = pkgs: (with pkgs; [ ]);
      runScript = ''
        env SHELL_NAME="node18" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
      '';
    })
    (pkgs.buildFHSUserEnv {
      name = "node20";
      targetPkgs = pkgs: (with pkgs; [ gradle adoptopenjdk-hotspot-bin-8 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv nodejs_20 watchman]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
      multiPkgs = pkgs: (with pkgs; [ ]);
      runScript = ''
        env SHELL_NAME="node20" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
      '';
    })
#    (pkgs.buildFHSUserEnv {
#      name = "qt5-shell";
#      targetPkgs = pkgs: (with pkgs; [ zlib zlib libGL bash qt5.full qtcreator ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
#      multiPkgs = pkgs: (with pkgs; [ ]);
#      runScript = ''
#        env SHELL_NAME="qt5-shell" bash --rcfile <(cat /home/ktor/.bashrc;)
#      '';
#    })
#    (pkgs.buildFHSUserEnv {
#      name = "node14";
#      targetPkgs = pkgs: (with pkgs; [ gradle adoptopenjdk-hotspot-bin-8 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv nodejs_14 ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
#      multiPkgs = pkgs: (with pkgs; [ ]);
#      runScript = ''
#        env SHELL_NAME="node14" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
#      '';
#    })
#    (pkgs.buildFHSUserEnv {
#      name = "watermark";
#      targetPkgs = pkgs: (with pkgs; [ gradle adoptopenjdk-hotspot-bin-8 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv imagemagick ghostscript]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
#      multiPkgs = pkgs: (with pkgs; [ ]);
#      runScript = ''
#        env SHELL_NAME="watermark" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
#      '';
#    })
  ];
}
