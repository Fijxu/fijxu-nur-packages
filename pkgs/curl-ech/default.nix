{
  curlFull,
  openssl_4_0,
  openssl-ech ? openssl_4_0,
  ...
}:

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
