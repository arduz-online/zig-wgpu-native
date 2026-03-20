{
  pkgs,
  inputs,
  ...
}: let
  zigPkg = inputs.zig-overlay.packages.${pkgs.stdenv.hostPlatform.system}."master-2026-03-18";
  zlsPkg = inputs.zls.packages.${pkgs.stdenv.hostPlatform.system}.zls;
in {
  packages = [zigPkg zlsPkg pkgs.bun];
}
