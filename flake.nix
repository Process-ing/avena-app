{
  description = "A basic flake for Flutter development with Nix and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      buildToolsVersion = "35.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        includeNDK = "if-supported";

        buildToolsVersions = [ buildToolsVersion ];
        cmakeVersions = [ "3.22.1" ];
        platformVersions = [ "36" ];
        ndkVersions = [ "28.2.13676358" ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell rec {
        env = {
          # Android environment variables
          ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";

          # Java environment variables
          JAVA_HOME = "${pkgs.jdk21}";

          GRADLE_OPTS = pkgs.lib.concatStringsSep " " [
            "-Dorg.gradle.project.android.aapt2FromMavenOverride=${env.ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2"
            # KMS pls ;w;
            # https://github.com/gradle/gradle/issues/33307
            "-Dorg.gradle.project.org.gradle.java.installations.auto-detect=false"
            "-Dorg.gradle.project.org.gradle.java.installations.auto-download=false"
            "-Dorg.gradle.project.org.gradle.java.installations.paths=${pkgs.jdk21}"
          ];
        };

        packages = [
          androidComposition.androidsdk
          pkgs.flutter
          pkgs.jdk21
        ];

        shellHook = ''
          export PATH="${env.ANDROID_HOME}/build-tools/${buildToolsVersion}:$PATH"
        '';
      };
    };
}
