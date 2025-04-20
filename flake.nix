{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
    packages.x86_64-linux = rec {
      default = dscanner;
      dscanner = pkgs.buildDubPackage rec {
        pname = "dscanner";
        version = "0.15.2";

        src = pkgs.fetchFromGitHub {
          owner = "dlang-community";
          repo = "D-Scanner";
          rev = "v${version}";
          hash = "sha256-7lZhYlK07VWpSRnzawJ2RL69/U/AH/qPyQY4VfbnVn4=";
        };

        dubLock = ./dub-lock.json;

        doCheck = true;

        installPhase = ''
          runHook preInstall
          install -Dm755 bin/dscanner -t $out/bin
          runHook postInstall
        '';
      };
    };
  };
}
