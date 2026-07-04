{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  yarn,
}:

let
  rev = "3e4a41a97904d55be2341e5ed93679259a0adbdf";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustlog";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "boring-nick";
    repo = "rustlog";
    inherit rev;
    fetchSubmodules = true;
    hash = "sha256-+/8Xk1wvJeAmAmlSiMsI+mp++VJ+Pj2Phh8kVQ0a/Dc=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-tyqpeAI6hu0YlTWvZMJekMU7lIHEOv137KP+ci+Cv7k=";
  };

  # preBuild = ''
  #   export HOME=$(mktemp -d)
  #   cd web
  #   yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
  #   fixup-yarn-lock yarn.lock
  #   yarn --offline --frozen-lockfile install --ignore-scripts --no-progress --non-interactive
  #   patchShebangs node_modules
  #   yarn build --offline
  #   cd ..
  # '';

  cargoHash = "sha256-JYG+t9Cs6t55kW2kYE1jEUYEs3XvpzVSxIjbszkd4Sw=";

  meta = {
    changelog = "https://github.com/boring-nick/rustlog/commit/${rev}";
    description = "Twitch logging service inspired by justlog";
    homepage = "https://github.com/boring-nick/rustlog";
    license = lib.licenses.mit;
    mainProgram = "rustlog";
    maintainers = with lib.maintainers; [ Fijxu ];
  };
})
