{
  # curl,
  curlFull,
  pkgs,
  ...
}:

let
  openssl-ech = pkgs.callPackage ../openssl-ech { };
in

(curlFull.override {
  openssl = openssl-ech;
}).overrideAttrs
  (old: {
    configureFlags = old.configureFlags ++ [ "--enable-ech" ];
    # postInstall = (old.postInstall or "") + ''
    #   mv bin/curl $out/bin/curl-ech
    # '';
    meta = old.meta // {
      mainProgram = "curl-ech";
    };
  })
