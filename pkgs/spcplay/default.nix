{
  stdenv,
  lib,
  fetchzip,
  makeDesktopItem,
  makeWrapper,
  icoutils,
  imagemagick,
  wineWow64Packages,
  winePackage ? wineWow64Packages.stable,
}:

let
  pname = "spcplay";
  package = {
    name = "SPCPlay";
    description = "SNES SPC700 Player";
  };
  desktopItem = makeDesktopItem {
    desktopName = pname;
    name = pname;
    exec = "${pname}";
    icon = pname;
    comment = package.description;
    type = "Application";
    categories = [
      "Audio"
      "Sequencer"
      "Midi"
      "Music"
      "AudioVideo"
    ];
    genericName = pname;
  };
in
stdenv.mkDerivation rec {
  inherit pname;
  version = "2.21.2.8822";
  name = "spcplay-bin";
  src = fetchzip {
    url = "https://github.com/dgrfactory/spcplay/releases/download/${version}/spcplay-${version}.zip";
    hash = "sha256-oByNuyg9n9nOso2q2PWYY4pCneX1T1u6ZITEmiD4yyc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    icoutils
    imagemagick
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps
    cp -r $src/* $out/bin/

    makeWrapper ${winePackage}/bin/wine $out/bin/${pname} \
      --add-flags "$out/bin/spcplay.exe"

    # Extract the icon from the .exe
    wrestool -x -t 14 $out/bin/spcplay.exe > spcplay.ico
    # Convert to png :3, the .ico has multiple resolutions, the [1] is the biggest one (48x48)
    magick spcplay.ico\[1\] spcplay.png

    install -Dm644 "spcplay.png" "$out/share/pixmaps/${pname}.png"
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications
  '';

  meta = with lib; {
    description = package.description;
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    homepage = "https://github.com/dgrfactory/spcplay";
  };
}
