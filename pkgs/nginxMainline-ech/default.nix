{
  nginxMainline,
  openssl_4_0,
  openssl-ech ? openssl_4_0,
  ...
}:

(nginxMainline.override {
  openssl = openssl-ech;
})
