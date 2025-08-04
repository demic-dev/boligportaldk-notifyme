{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name       = "BoligPortal.dk NotifyMe";
  buildInputs = [
    pkgs.python310
    pkgs.python310Packages.requests
    pkgs.python310Packages.beautifulsoup4
    pkgs.python310Packages.python-dotenv
  ];
  src         = ./.;
  installPhase = ''
    mkdir -p $out/bin
    cp main.py $out/bin/
  '';
}
