# fijxu-nur-packages

Packages that I packaged for myself.

## Using the packages

1. Add the input to your `flake.nix`:

```nix
  # flake.nix

  inputs = {
    # ... Your other inputs that are above this one
    fijxu-nur-packages = {
      url = "git+https://codeberg.org/fijxu/fijxu-nur-packages";
    };
  };
```

2. Add the default overlay

```nix
# configration.nix

{
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.fijxu-nur-packages.overlays.default
  ];
}
```

To prevent overwritting packages from `nixpkgs`, I used different package names for the packages that are available here, check those [here](./overlays/default.nix)

## Packages

- [SPCPlay](./pkgs/spcplay/default.nix): <https://github.com/dgrfactory/spcplay>
- [OpenMPT](./pkgs/openmpt/default.nix): <https://openmpt.org>

## Deprecated packages

This packages are not needed anymore as you can build HAproxy with the package `openssl_4_0` from `nixpkgs`.

- [HAProxy 3.3.4 with ECH](./pkgs/haproxy-ech/default.nix): <https://github.com/haproxy/haproxy>
  - A build of HAProxy with ECH enabled using [OpenSSL with ECH](./pkgs/openssl-ech/default.nix), (only works in x86-64-v3 CPUs because I'm too lazy to make adapt the Nix package to other shit).
  - This package is being used in production for https://nadeko.net selfhosted services.
- [OpenSSL 4.0.0-dev with ECH](./pkgs/openssl-ech/default.nix): <https://github.com/openssl/openssl/tree/feature/ech>
  - Build of OpenSSL using the `feature/ech` branch, used for [HAProxy with ECH](./pkgs/haproxy-ech/default.nix)
