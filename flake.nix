{
  description = "Nix packages for PhotoCraft and EffectCraft";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = {
        photocraft = pkgs.callPackage ./pkgs/photocraft { };
        effectcraft = pkgs.callPackage ./pkgs/effectcraft { };

        default = self.packages.${system}.photocraft;
      };
    };
}