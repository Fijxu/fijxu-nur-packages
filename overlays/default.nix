{
  default = final: prev: {
    haproxy-ech = final.callPackage ../pkgs/haproxy-ech { };
    openssl-ech = final.callPackage ../pkgs/openssl-ech { };
    openmpt-bin = final.callPackage ../pkgs/openmpt { };
    spcplay-bin = final.callPackage ../pkgs/spcplay { };
  };
}
