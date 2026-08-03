{
  writeShellApplication,
  freerdp,
  gawk,
}:

writeShellApplication {
  name = "mtgo";

  runtimeInputs = [
    freerdp
    gawk
  ];

  text = builtins.readFile ./mtgo.sh;
}
