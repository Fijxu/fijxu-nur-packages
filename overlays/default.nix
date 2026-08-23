{ self }:
{
  default = final: prev: {
    openmpt-bin = self.legacyPackages.${final.system}.openmpt-bin;
    spcplay-bin = self.legacyPackages.${final.system}.spcplay-bin;
    rustlog = self.legacyPackages.${final.system}.rustlog;
  };
}
