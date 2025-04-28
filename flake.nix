{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux = {
        dscanner = pkgs.buildDubPackage rec {
          pname = "dscanner";
          version = "0.15.2";

          src = pkgs.fetchFromGitHub {
            owner = "dlang-community";
            repo = "D-Scanner";
            rev = "v${version}";
            hash = "sha256-7lZhYlK07VWpSRnzawJ2RL69/U/AH/qPyQY4VfbnVn4=";
          };

          dubLock = ./dscanner-dub-lock.json;

          doCheck = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 bin/dscanner -t $out/bin
            runHook postInstall
          '';
        };

        dfmt = pkgs.buildDubPackage rec {
          pname = "dfmt";
          version = "0.15.2";

          src = pkgs.fetchFromGitHub {
            owner = "dlang-community";
            repo = "dfmt";
            tag = "v${version}";
            hash = "sha256-QjmYPIQFs+91jB1sdaFoenfWt5TLXyEJauSSHP2fd+M=";
          };

          preBuild = ''
            mkdir -p bin/
            echo ${src.tag} > bin/dubhash.txt
          '';

          patches = [
            ./dfmt_fix_version.patch
          ];

          dubLock = ./dfmt-dub-lock.json;

          doCheck = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 bin/dfmt -t $out/bin
            runHook postInstall
          '';

          nativeInstallCheckInputs = with pkgs; [
            versionCheckHook
          ];

          doInstallCheck = true;
        };
      };
    };
}
