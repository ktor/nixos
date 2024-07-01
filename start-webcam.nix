# start-webcam.nix
with import <nixpkgs> { };

writeShellScriptBin "start-webcam" ''
  systemctl restart webcam
  # debugging example
  # echo "hello" &> /home/tom/myfile.txt
  # If myfile.txt gets created then we know the udev rule has triggered properly
''
