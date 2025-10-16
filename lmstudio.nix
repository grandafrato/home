{
  appimageTools,
  fetchurl,
  stdenv,
  lib,
}: let
  pname = "lmstudio";
  version = "0.3.30-1";
  src = fetchurl {
    url = "https://installers.lmstudio.ai/linux/x64/${version}/LM-Studio-${version}-x64.AppImage";
    hash = "sha256-tdIW6xQrnlKhc9oS/nzVfywQHKqlVikCDPuk5lh+ROE=";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: [pkgs.ocl-icd];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
      install -m 444 -D ${appimageContents}/lm-studio.desktop -t $out/share/application

      install -m 755 ${appimageContents}/resources/app/.webpack/lms $out/bin/

      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
      --set-rpath "${lib.getLib stdenv.cc.cc}/lib:${lib.getLib stdenv.cc.cc}/lib64:$out/lib:${
        lib.makeLibraryPath [(lib.getLib stdenv.cc.cc)]
      }" $out/bin/lms
    '';
  }
