{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "wl-clipboard-rs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AmGUYmwMtvb1WbCA+x0P6/C3I8ISVA/tc1TScjn1gEU=";
  };

  cargoBuildFlags = [
    "--package wl-clipboard-rs-tools"
  ];
  cargoHash = lib.fakeHash;
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    find ./target -name wl-clip -type f -exec cp {} $out/bin \;
    find ./target -name wl-copy -type f -exec cp {} $out/bin \;
    find ./target -name wl-paste -type f -exec cp {} $out/bin \;
  '';

  meta = with lib; {
    description = "A pure Rust Wayland clipboard manager";
    homepage = "https://github.com/YaLTeR/wl-clipboard-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
