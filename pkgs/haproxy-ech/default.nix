{
  haproxy,
  fetchurl,
  lib,
  openssl_4_0,
  openssl-ech ? openssl_4_0,
  ...
}:

let
  version = "3.4.0";
  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/haproxy-${version}.tar.gz";
    hash = "sha256-kpj1ZcKpuopOf4nFS+LF0/2WC1swTrVRXhXSnSwV1Pc=";
  };
in

(haproxy.override {
  openssl = openssl-ech;
}).overrideAttrs
  (old: {
    inherit version;
    inherit src;
    buildFlags = old.buildFlags ++ [ "USE_ECH=1" ];
  })
