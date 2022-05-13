{ pkgs ? import <nixpkgs> {} }:
let env = pkgs.poetry2nix.mkPoetryEnv {
  python = pkgs.python3;
  projectDir = ./.;
};
in env.env
