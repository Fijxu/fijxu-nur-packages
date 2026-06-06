{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

let
  pname = "synapse_auto_compressor";
in
rustPlatform.buildRustPackage rec {
  inherit pname;
  version = "9e01ee361b5c729beb5d53a1ae433d8f2bdeca12";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "rust-synapse-compress-state";
    rev = version;
    hash = "sha256-zoJMN7AJQwNSzIeCMDMw5aKO/kIOL4u/B1d+tp7/Zqc=";
  };

  sourceRoot = "${src.name}/synapse_auto_compressor";

  cargoLock.lockFile = ./Cargo.lock;
  cargoLock.allowBuiltinFetchGit = true;
  cargoHash = "sha256-ELAwlJIsdCN+HTbkOD+79Vnzwe1fOI9DduRDtrLtKEc=";

  meta = with lib; {
    description = "A tool to compress some state in a Synapse instance's database";
    license = licenses.asl20;
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
  };
}
