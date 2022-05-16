self: super:
{
  jetbrains = super.jetbrains // {
    jdk = super.jetbrains.jdk.overrideAttrs (oldAttrs: rec {
      version = "17_0_2-linux-x64-b315.1";
      src = super.fetchurl {
        url = "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-17_0_2-linux-x64-b315.1.tar.gz";
        sha256 = "sha256-ImnQgErO3f7lNVHSSCKaPAD3RMsK2jmdA6VWX2WI2qA=";
      };

      dontStrip = true; # See: https://github.com/NixOS/patchelf/issues/10
      postFixup = ''
        rpath="$out/lib/jli:$out/lib/server:$out/lib:${
          self.lib.makeLibraryPath (with super; [
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
          libudev
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
        printWords ${self.setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
        cat <<EOF >> $out/nix-support/setup-hook
        if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
        EOF
      '';

      passthru.jre = self.jetbrains.jre;
      passthru.home = self.jetbrains.home;
      meta = with super.lib; { platforms = [ "x86_64-linux" ]; };
    });
    idea-ultimate = super.jetbrains.idea-ultimate.override{
  # defaults as of 2021.2.3
  # -Xmx750m
  # -Xms128m
  # -XX:ReservedCodeCacheSize=512m
  # -XX:+UseG1GC
  # -XX:SoftRefLRUPolicyMSPerMB=50
  # -XX:CICompilerCount=2
  # -XX:+HeapDumpOnOutOfMemoryError
  # -XX:-OmitStackTraceInFastThrow
  # -ea
  # -Dsun.io.useCanonCaches=false
  # -Djdk.http.auth.tunneling.disabledSchemes=""
  # -Djdk.attach.allowAttachSelf=true
  # -Djdk.module.illegalAccess.silent=true
  # -Dkotlinx.coroutines.debug=off
  # -Dsun.tools.attach.tmp.only=true
  vmopts = ''
    -Xms64m
    -Xmx12g
    -XX:ReservedCodeCacheSize=512m
    -XX:+UseZGC
    -XX:+UseTransparentHugePages
    -XX:+AlwaysPreTouch
    -XX:ZUncommitDelay=150
    -Dnosplash=true
    --add-opens=java.base/java.lang=ALL-UNNAMED
    --add-opens=java.base/java.text=ALL-UNNAMED
    --add-opens=java.base/java.util=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.vm=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.desktop/com.apple.eawt=ALL-UNNAMED
    --add-opens=java.desktop/com.apple.eawt.event=ALL-UNNAMED
    --add-opens=java.desktop/com.apple.laf=ALL-UNNAMED
    --add-opens=java.desktop/java.awt=ALL-UNNAMED
    --add-opens=java.desktop/java.awt.event=ALL-UNNAMED
    --add-opens=java.desktop/java.awt.peer=ALL-UNNAMED
    --add-opens=java.desktop/javax.swing=ALL-UNNAMED
    --add-opens=java.desktop/javax.swing.plaf.basic=ALL-UNNAMED
    --add-opens=java.desktop/javax.swing.text.html=ALL-UNNAMED
    --add-opens=java.desktop/sun.awt=ALL-UNNAMED
    --add-opens=java.desktop/sun.awt.datatransfer=ALL-UNNAMED
    --add-opens=java.desktop/sun.awt.image=ALL-UNNAMED
    --add-opens=java.desktop/sun.awt.windows=ALL-UNNAMED
    --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED
    --add-opens=java.desktop/sun.font=ALL-UNNAMED
    --add-opens=java.desktop/sun.java2d=ALL-UNNAMED
    --add-opens=java.desktop/sun.swing=ALL-UNNAMED
    --add-opens=jdk.attach/sun.tools.attach=ALL-UNNAMED
    --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED
    --add-opens=jdk.jdi/com.sun.tools.jdi=ALL-UNNAMED
    --add-opens=jdk.jdi/com.sun.tools.jdi=ALL-UNNAMED'

    -XX:SoftRefLRUPolicyMSPerMB=50
    -XX:+HeapDumpOnOutOfMemoryError
    -XX:-OmitStackTraceInFastThrow
    -ea
    -Dsun.io.useCanonCaches=false
    -Djdk.http.auth.tunneling.disabledSchemes=""
    -Djdk.attach.allowAttachSelf=true
    -Djdk.module.illegalAccess.silent=true
    -Dkotlinx.coroutines.debug=off
    -Dsun.tools.attach.tmp.only=true

    # https://intellij-support.jetbrains.com/hc/en-us/articles/360007994999-HiDPI-configuration
    # only consider user scale
    -Dsun.java2d.uiScale.enabled=false
    -Dide.ui.scale=1.4
  '';
}.overrideAttrs (_: {
  name = "idea-ultimate-${super.version}";

  inherit (self.sources.idea-ultimate) version src;

  nativeBuildInputs = [ super.makeWrapper super.wrapGAppsHook ];

  postFixup = ''
            for f in $(find $out -type f -perm -0100); do
              wrapProgram "$f" \
                --prefix PATH : "${self.lib.makeBinPath [ super.python3 ]}" \
                --run "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${self.lib.makeLibraryPath [ super.glib ]}"
            done
  '';
});
  };
}
