{ self }:
{
  default = final: prev: {
    haproxy-ech = self.legacyPackages.${final.system}.haproxy-ech;
    openssl-ech = self.legacyPackages.${final.system}.openssl-ech;
    openmpt-bin = self.legacyPackages.${final.system}.openmpt-bin;
    spcplay-bin = self.legacyPackages.${final.system}.spcplay-bin;
    rustlog = self.legacyPackages.${final.system}.rustlog;
  };
}
