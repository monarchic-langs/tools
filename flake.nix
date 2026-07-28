{
  description = "Nix package for gopls";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    packages.${system}.default = pkgs.gopls;
    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.gopls pkgs.go];
    };
  };
}
