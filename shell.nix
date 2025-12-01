{
  pkgs ? import <nixpkgs> { },
}:
{
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      elixir
      python3
    ];
  };
}
