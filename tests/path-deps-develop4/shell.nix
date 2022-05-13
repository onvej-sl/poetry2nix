{ pkgs ? import <nixpkgs> {} }:
let env = pkgs.poetry2nix.mkPoetryEnv {
  python = pkgs.python3;
  projectDir = ./.;
  editablePackageSources = {
    dep1 = null;
  };
};
in env.env
