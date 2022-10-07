final: prev: {
  jetbrains = prev.jetbrains // {
    jdk = prev.jetbrains.jdk.overrideAttrs (oldAttrs: rec {
      version = "17.0.4.1-linux-x64-b629.2";
      src = prev.fetchurl {
        url = "https://cache-redirector.jetbrains.com/intellij-jbr/jbrsdk_jcef-${version}.tar.gz";
        sha256 = "sha256-QwS6n4VUr+2OeAeaEa3QRar9kmpG5O+LbzQnBDkW46M=";
      };
      dontConfigure = true;
      dontStrip = true; # See: https://github.com/NixOS/patchelf/issues/10
      postFixup = ''
        rpath="$out/lib/jli:$out/lib/server:$out/lib:${
          final.lib.makeLibraryPath (with prev; [
            zlib
            xorg.libX11
            xorg.libXext
            xorg.libXtst
            xorg.libXi
            xorg.libXrender
            freetype
            alsa-lib
            atk
            at-spi2-atk
            at-spi2-core
            cups
            dbus
            expat
            fontconfig
            glib
            libdrm
            libxkbcommon
            mesa
            nspr
            nss
            stdenv.cc.cc.lib
            xorg.libxcb
            xorg.libXcomposite
            xorg.libXcursor
            xorg.libXdamage
            xorg.libXfixes
            xorg.libXrandr
            xorg.libxshmfence
            xorg.libXxf86vm
          # runtime?
          libglvnd
          udev
          mesa.drivers
        ])
      }"
        for f in $(find $out -name "*.so") $(find $out -type f -perm -0100); do
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f" || true
        patchelf --set-rpath   "$rpath"                                    "$f" || true
        done
        for f in $(find $out -name "*.so") $(find $out -type f -perm -0100); do
        if ldd "$f" | fgrep 'not found'; then echo "in file $f"; fi
        done
      '';

      installPhase = ''
        mv ../$sourceRoot $out
        mkdir -p $out/nix-support
        printWords ${final.setJavaClassPath} > $out/nix-support/propagated-build-inputs
      # Set JAVA_HOME automatically.
        cat <<EOF >> $out/nix-support/setup-hook
        if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
        EOF
      '';
      passthru = oldAttrs.passthru // {
        home = "${final.jetbrains.jdk}/Contents/Home";
      };
    });
    # Control the version of Intellij ourselves and add the plugin.
    idea-ultimate = prev.jetbrains.idea-ultimate.overrideAttrs (old: rec {
      version = "2022.2.3";
      src = prev.fetchurl {
        url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jbr.tar.gz";
        sha256 = "dFTX4Lj049jYBd3mRdKLhCEBvXeuqLKRJYgMWS5rjIU=";
      };
    });
  };
}
