{
  pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
  },
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    steamcmd
    p7zip
  ];
}
