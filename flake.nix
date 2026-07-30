{
  description = "Nix package for gopls";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    packages.${system}.default = pkgs.gopls;
    checks = {
      ${system} = {
        inherit (self.packages.${system}) default;

        flake-format =
          pkgs.runCommand "tools-flake-format-check"
          {nativeBuildInputs = [pkgs.alejandra];}
          ''
            alejandra --check ${./flake.nix}
            touch $out
          '';

        gopls-smoke =
          pkgs.runCommand "tools-gopls-smoke"
          {nativeBuildInputs = [self.packages.${system}.default];}
          ''
            gopls version
            touch $out
          '';
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.gopls pkgs.go];
    };
  };
}
