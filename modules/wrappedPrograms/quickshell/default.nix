{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.quickshell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = inputs'.qml-niri.packages.quickshell;

      flags = {
        "-c" = toString ./.;
      };
    };
  };
}
