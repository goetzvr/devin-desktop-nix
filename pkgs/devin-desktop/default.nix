{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "devin-desktop";
  version = "3.10.35";

  src = pkgs.fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64-deb/stable/dfa4a2d639b8a05ab72387c12f1aafca1b4c3cb9/Devin-linux-x64-3.10.35.deb";
    sha256 = "e6eda55f2ceef5287fa7400de95ea2d49e84400a5f36d63299b6f1a221c225a9";
  };

  nativeBuildInputs = [
    pkgs.dpkg
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    glib-networking
    libgpg-error
    libffi
    pcre2
    libselinux
    libsepol
    gtk3
    nss
    mesa
    alsa-lib
    libsecret
    libXScrnSaver
    libXtst
    libxkbcommon
    expat
    cups
    libxkbfile
    libXrandr
    libX11
    libXi
    libGL
    libXxf86vm
    nspr
    atk
    cairo
    pango
    webkitgtk_4_1
    libsoup_3
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar --no-same-permissions --no-same-owner -xf -
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out/

    # Create symlink as done in aur-build
    install -dm755 $out/bin
    ln -sf "../share/devin-desktop/bin/devin-desktop" $out/bin/devin-desktop

    # Fix desktop file paths
    substituteInPlace $out/share/applications/devin-desktop.desktop \
      --replace-fail "/usr/share/devin-desktop/devin-desktop" "$out/bin/devin-desktop" \
      --replace-fail "Icon=devin-desktop" "Icon=$out/share/pixmaps/devin-desktop.png"

    substituteInPlace $out/share/applications/devin-desktop-url-handler.desktop \
      --replace-fail "/usr/share/devin-desktop/devin-desktop" "$out/bin/devin-desktop" \
      --replace-fail "Icon=devin-desktop" "Icon=$out/share/pixmaps/devin-desktop.png"
  '';

  meta = with pkgs.lib; {
    description = "A team of agents for every engineer — Devin Desktop";
    platforms = platforms.linux;
  };
}
