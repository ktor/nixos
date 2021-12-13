{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (pkgs.buildFHSUserEnv {
      name = "lukreo";
      targetPkgs = pkgs: (with pkgs; [ gradle adoptopenjdk-hotspot-bin-8 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv nodejs-10_x ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
      multiPkgs = pkgs: (with pkgs; [ ]);
      runScript = ''
        env SHELL_NAME="lukreo" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
      '';
    })
    (pkgs.buildFHSUserEnv {
      name = "o2";
      targetPkgs = pkgs: (with pkgs; [ gradle adoptopenjdk-hotspot-bin-8 gnumake zlib zlib libGL gitAndTools.gitFull bash-completion bash direnv nodejs-14_x ]) ++ (with pkgs.xorg; [ libXi libXxf86vm libX11 ]);
      multiPkgs = pkgs: (with pkgs; [ ]);
      runScript = ''
        env SHELL_NAME="o2" bash --rcfile <(cat /home/ktor/.bashrc; echo 'source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-completion.bash"; source "${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh";')
      '';
    })
  ];
}
