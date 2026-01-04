{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      python = pkgs.python3.withPackages (ps: [ ps.feedparser ]);
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          python
          pkgs.whisper-cpp
          pkgs.ffmpeg
          pkgs.parallel
          pkgs.curl
        ];
      };
    };
}
