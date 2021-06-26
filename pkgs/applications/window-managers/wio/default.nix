{ lib
, stdenv
, fetchFromBitbucket
, fetchpatch
, meson
, ninja
, pkg-config
, alacritty
, cage
, cairo
, libxkbcommon
, udev
, wayland
, wayland-protocols
, wlroots
, mesa
, xwayland
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "wio";
  version = "0.0.0+unstable=2021-06-01";

  src = fetchFromBitbucket {
    owner = "anderson_torres";
    repo = pname;
    rev = "ad57eb45ba0459cd0b16ba486cb6e01626079c29";
    sha256 = "sha256-mCggAscQ+Ej3SNwhA6QxecV1nH6Rw8RDf8yAsbadqjE=";
  };

  patches = [
    # Fix the build with wlroots 0.14:
    (fetchpatch {
      url = "https://git.sr.ht/~primeos/wio/commit/9d5093c019f6966b8ee0dba1da3361a761d04bcc.patch";
      sha256 = "08hfmcs1fbz8pdxwcaidrhvydf19482i6wics75a41ilrdh0dpi1";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    cairo
    libxkbcommon
    mesa # for libEGL
    udev
    wayland
    wayland-protocols
    wlroots
    xwayland
  ];

  postInstall = ''
    wrapProgram $out/bin/wio \
      --prefix PATH ":" "${lib.makeBinPath [ alacritty cage ]}"
  '';

  meta = with lib; {
    homepage = "https://wio-project.org/";
    description = "That Plan 9 feel, for Wayland";
    longDescription = ''
      Wio is a Wayland compositor for Linux and FreeBSD which has a similar look
      and feel to plan9's rio.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };

  passthru.providedSessions = [ "wio" ];
}
# TODO: factor Linux-specific options
