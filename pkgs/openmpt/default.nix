{
  stdenv,
  lib,
  fetchzip,
  makeDesktopItem,
  makeWrapper,
  imagemagick,
  wineWow64Packages,
  winePackage ? wineWow64Packages.stable,
}:

let
  pname = "openmpt";
  package = {
    name = "OpenMPT";
    description = "Open-source audio module tracker";
  };
  desktopItem = makeDesktopItem {
    desktopName = package.name;
    name = package.name;
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
    genericName = package.name;
  };
in
stdenv.mkDerivation rec {
  inherit pname;
  version = "1.32.11.00";
  name = "openmpt-bin";
  src = fetchzip {
    url = "https://download.openmpt.org/archive/openmpt/${lib.versions.majorMinor version}/OpenMPT-${version}-portable-amd64.zip";
    hash = "sha256-zCm3vM9WqYv6DBdqNJwZeYWdLCvUqJc2SfzECH8FTXs=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];

  installPhase = ''
    mkdir -p $out/share/applications $out/share/pixmaps $out/share/${pname}
    cp -r $src/* $out/share/${pname}/

    makeWrapper ${winePackage}/bin/wine $out/bin/openmpt \
      --add-flags "$out/share/openmpt/OpenMPT.exe"

    # Convert to png :3, the .ico has multiple resolutions, the [2] is the biggest one (256x256)
    magick OpenMPT\ File\ Icon.ico\[2\] ${pname}.png

    # Since OpenMPT 1.29, portable installations are identified by the presence of the "OpenMPT.portable" file.
    # That file is removed here to keep existing installations configured properly.
    # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=openmpt&id=a84aa323c8ac9f6ee5cf23979f97e6722369c002#n47
    rm "$out/share/${pname}/OpenMPT.portable"

    install -Dm644 "${pname}.png" "$out/share/pixmaps/${pname}.png"
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications
  '';

  meta = with lib; {
    description = package.description;
    platforms = platforms.linux;
    license = licenses.bsd3;
    homepage = "https://openmpt.org";
  };
}
