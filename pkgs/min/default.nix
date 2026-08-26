{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook3
, makeWrapper
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, libdrm
, libnotify
, libxkbcommon
, mesa
, nspr
, nss
, pango
, systemd
, pulseaudio
, xorg
, libGL
, libgbm ? mesa   # some nixpkgs versions expose libgbm separately
}:

stdenv.mkDerivation rec {
  pname = "min-browser";
  version = "1.35.7";

  src = fetchurl {
    url = "https://github.com/minbrowser/min/releases/download/v${version}/min-${version}-amd64.deb";
    sha256 = "11741cb9606b68dc5f8371c335571e72726acefd5e8c327638e80e9f14ab737f";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    pulseaudio
    libGL
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libXtst
    xorg.libxshmfence
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" ./deb-root
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    # /opt/Min, /usr/share/{applications,icons,doc} -> $out/{opt,share}
    cp -r deb-root/opt $out/opt
    cp -r deb-root/usr/share $out/share

    mkdir -p $out/bin
    ln -s $out/opt/Min/min $out/bin/min

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libnode.so.108"
  ];

  postFixup = ''
    if [ -f "$out/share/applications/min.desktop" ]; then
      substituteInPlace "$out/share/applications/min.desktop" \
        --replace "/opt/Min/min" "$out/bin/min"
    fi

    wrapProgram $out/opt/Min/min \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform=wayland}" \
      --set-default ELECTRON_IS_DEV 0 \
      --set-default ELECTRON_ENABLE_LOGGING 1 \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pulseaudio ]}"
  '';

  meta = with lib; {
    description = "Fast, minimal, privacy-focused web browser (unofficial .deb-based package)";
    homepage = "https://min.browser.digital";
    downloadPage = "https://github.com/minbrowser/min/releases";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    mainProgram = "min";
  };
}
