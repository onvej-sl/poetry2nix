let
  sources = import ../nix/sources.nix;
in
{ pkgs ? import sources.nixpkgs {
    config = {
      allowAliases = false;
    };
    overlays = [
      (import ../overlay.nix)
    ];
  }
}:
let
  poetry = pkgs.callPackage ../pkgs/poetry { python = pkgs.python3; inherit poetry2nix; };
  poetry2nix = import ./.. { inherit pkgs; inherit poetry; };
  poetryLib = import ../lib.nix { inherit pkgs; lib = pkgs.lib; stdenv = pkgs.stdenv; };
  pep425 = pkgs.callPackage ../pep425.nix { inherit poetryLib; python = pkgs.python3; };
  pep425Python37 = pkgs.callPackage ../pep425.nix { inherit poetryLib; python = pkgs.python37; };
  pep425OSX = pkgs.callPackage ../pep425.nix { inherit poetryLib; isLinux = false; python = pkgs.python3; };
  skipTests = builtins.filter (t: builtins.typeOf t != "list") (builtins.split "," (builtins.getEnv "SKIP_TESTS"));
  callTest = test: attrs: pkgs.callPackage test ({ inherit poetry2nix; } // attrs);

  # HACK: Return null on MacOS since the test in question fails
  skipOSX = drv: if pkgs.stdenv.isDarwin then builtins.trace "Note: Skipping ${drv.name} on OSX" (pkgs.runCommand drv.name { } "touch $out") else drv;

in
builtins.removeAttrs
{
  path-deps-develop2 = callTest ./path-deps-develop2 { };
  path-deps-develop3 = callTest ./path-deps-develop3 { };
  path-deps-develop4 = callTest ./path-deps-develop4 { };
}
  skipTests
