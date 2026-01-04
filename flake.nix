{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          python = pkgs.python3.withPackages (ps: [
            ps.feedparser
            ps.beautifulsoup4
            ps.markdownify
          ]);
        in
        {
          default = pkgs.mkShell {
            packages = [
              python
              pkgs.whisper-cpp
              pkgs.ffmpeg
              pkgs.parallel
              pkgs.curl
            ];
          };
        }
      );
    };
}
