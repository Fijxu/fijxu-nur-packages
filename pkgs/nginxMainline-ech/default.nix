{
  nginxMainline,
  pkgs,
  ...
}:

let
  openssl-ech = pkgs.callPackage ../openssl-ech { };
in

(nginxMainline.override {
  openssl = openssl-ech;
})
