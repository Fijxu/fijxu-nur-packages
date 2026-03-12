{
  default = final: prev: {
    haproxy-ech = prev.callPackage ../pkgs/haproxy-ech { };
    openssl-ech = prev.callPackage ../pkgs/openssl-ech { };
    openmpt-bin = prev.callPackage ../pkgs/openmpt { };
    spcplay-bin = prev.callPackage ../pkgs/spcplay { };
  };
}
