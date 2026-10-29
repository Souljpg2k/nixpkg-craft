# nixpkg-craft

Nix packages for PhotoCraft and EffectCraft, built from the official release archives (`x86_64-linux` only).

| Package | Upstream | Version |
|---|---|---|
| `photocraft` (default) | https://github.com/storytold/photocraft | `v0.17.0` |
| `effectcraft` | https://github.com/storytold/effectcraft | `v0.18.0` |

## Usage

```sh
nix run github:Souljpg2k/nixpkg-craft
nix run github:Souljpg2k/nixpkg-craft#effectcraft
```

In a NixOS or home-manager config:

```nix
inputs.craftnix = {
  url = "github:Souljpg2k/nixpkg-craft";
  inputs.nixpkgs.follows = "nixpkgs";
};
# ...
environment.systemPackages = [
  inputs.craftnix.packages.x86_64-linux.photocraft
  inputs.craftnix.packages.x86_64-linux.effectcraft
];
```