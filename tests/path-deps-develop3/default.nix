{ lib, poetry2nix, python3, runCommand }:

let env = poetry2nix.mkPoetryEnv {
  python = python3;
  projectDir = ./.;
};

in
lib.debug.runTests {
  testDepFound = {
    expected = "0\n";
    expr = builtins.readFile (runCommand "path-deps-develop-import" { } ''
      echo using ${env}
      ${env}/bin/python -c 'import dep1'
      echo $? > $out
    '');
  };
}
