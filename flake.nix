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
            tag = "v${version}";
            hash = "sha256-7lZhYlK07VWpSRnzawJ2RL69/U/AH/qPyQY4VfbnVn4=";
          };

          preBuild = ''
            mkdir -p bin/
            echo "v${version}" > bin/dubhash.txt
          '';

          patches = [
            ./dscanner_fix_version.patch
          ];

          dubLock = ./dscanner-dub-lock.json;

          doCheck = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 bin/dscanner -t $out/bin
            runHook postInstall
          '';

          nativeInstallCheckInputs = with pkgs; [
            versionCheckHook
          ];

          doInstallCheck = true;
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
            echo "v${version}" > bin/dubhash.txt
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

        dpp = pkgs.buildDubPackage rec {
          pname = "dpp";
          version = "0.6.0";

          src = pkgs.fetchFromGitHub {
            owner = "atilaneves";
            repo = "dpp";
            tag = "v${version}";
            hash = "sha256-8zcjZ8EV5jdZrRCHkzxu9NeehY2/5AfOSdzreFC9z3c=";
          };

          nativeBuildInputs = with pkgs; [ dtools ];
          buildInputs = with pkgs; [ libclang ];

          dubLock = ./dpp-dub-lock.json;

          installPhase = ''
            runHook preInstall
            install -Dm755 bin/d++ -t $out/d++
            runHook postInstall
          '';
        };
      };
    };
}
