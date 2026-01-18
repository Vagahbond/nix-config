{ lib }:
{
  isDarwin = system: (lib.strings.hasInfix "darwin" system);
}
