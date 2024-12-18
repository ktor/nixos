final: prev: {
  jetbrains = prev.jetbrains // {
    # Get info from site...
    copilot-plugin-info = final.jetbrains.plugins.getUrl {
      id = "17718";
      hash = "sha256-Cjt/FMLVKR9RGmnM4pZLxgTuw+STbOkRO91HIEoacZ0=";
    };
    # Actually build the plugin
    copilot-plugin = final.jetbrains.plugins.urlToDrv (final.jetbrains.copilot-plugin-info // {
        hash = "sha256-XuQWI+kbck1BqnTvMfK6o85u9spksBkPhfcmFzs4VvI=";
        extra = {
          inputs = [prev.patchelf prev.glibc prev.gcc-unwrapped];
          commands = let
            libPath = prev.lib.makeLibraryPath [prev.glibc prev.gcc-unwrapped];
          in ''
            agent="copilot-agent/bin/copilot-agent-linux"
            orig_size=$(stat --printf=%s $agent)
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $agent
            patchelf --set-rpath ${libPath} $agent
            chmod +x $agent
            new_size=$(stat --printf=%s $agent)
            # https://github.com/NixOS/nixpkgs/pull/48193/files#diff-329ce6280c48eac47275b02077a2fc62R25
            ###### zeit-pkg fixing starts here.
            # we're replacing plaintext js code that looks like
            # PAYLOAD_POSITION = '1234                  ' | 0
            # [...]
            # PRELUDE_POSITION = '1234                  ' | 0
            # ^-----20-chars-----^^------22-chars------^
            # ^-- grep points here
            #
            # var_* are as described above
            # shift_by seems to be safe so long as all patchelf adjustments occur
            # before any locations pointed to by hardcoded offsets
            var_skip=20
            var_select=22
            shift_by=$(expr $new_size - $orig_size)
            function fix_offset {
              # $1 = name of variable to adjust
              location=$(grep -obUam1 "$1" $agent | cut -d: -f1)
              location=$(expr $location + $var_skip)
              value=$(dd if=$agent iflag=count_bytes,skip_bytes skip=$location \
                bs=1 count=$var_select status=none)
              value=$(expr $shift_by + $value)
              echo -n $value | dd of=$agent bs=1 seek=$location conv=notrunc
            }
            fix_offset PAYLOAD_POSITION
            fix_offset PRELUDE_POSITION
          '';
        };
      });
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
      version = "2024.3";
      src = prev.fetchurl {
        url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jbr.tar.gz";
        sha256 = "dFTX4Lj049jYBd3mRdKLhCEBvXeuqLKRJYgMWS5rjIU=";
      };
      plugins = [final.jetbrains.copilot-plugin];
    });
  };
}
