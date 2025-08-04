{
  description = "BoligPortal.dk NotifyMe";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # always import nixpkgs as a function
        pkgs = import nixpkgs {
          inherit system;
        };

        # your Python environment
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          beautifulsoup4
          python-dotenv
          requests
        ]);
      in {
        # `nix develop .#devShells.default` (or with #<system> prefix)
        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ];
        };

        # `nix build .#packages.default`
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "notifyme";
          version = "0.1";

          src = ./.;
          buildInputs = [ pythonEnv ];

          installPhase = ''
            mkdir -p $out/bin
            cp script.py $out/bin/notifyme.py
            wrapProgram $out/bin/notifyme.py \
              --set PYTHONPATH ${pythonEnv}/${pkgs.python3.sitePackages}
          '';
        };
      }
    );
}
