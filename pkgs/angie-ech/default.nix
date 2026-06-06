{
  angie,
  openssl_4_0,
  openssl-ech ? openssl_4_0,
  ...
}:

(angie.override {
  openssl = openssl-ech;
})
