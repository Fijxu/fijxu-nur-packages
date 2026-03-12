{

  haproxy,
  fetchFromGitHub,
  pkgs,
  ...
}:

let
  openssl-ech = pkgs.callPackage ../openssl-ech { };
  tag = "v3.4-dev6";
  src = fetchFromGitHub {
    owner = "haproxy";
    repo = "haproxy";
    tag = tag;
    hash = "sha256-IJk8+6DcjkintWMA03IRDDGI3pOloPGoqeLiX5KD0sQ=";
  };
in

(haproxy.override {
  openssl = openssl-ech;
}).overrideAttrs
  (old: {
    version = tag;
    inherit src;
    buildFlags = old.buildFlags ++ [ "USE_ECH=1" ];
    env.NIX_CFLAGS_COMPILE = "-march=x86-64-v3 -flto=auto";
  })
