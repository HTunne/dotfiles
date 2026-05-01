{
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.pass-menu = pkgs.writeShellApplication {
      name = "pass-menu";
      runtimeInputs = [pkgs.pass pkgs.fd pkgs.gnused pkgs.walker];
      text = ''
        pushd "$PASSWORD_STORE_DIR" || exit
        password=$(${lib.getExe pkgs.fd} --extension gpg | ${lib.getExe pkgs.gnused} 's/\.gpg//' | ${lib.getExe pkgs.walker} -d)
        [[ -n $password ]] || exit
        ${lib.getExe pkgs.pass} show -c "$password" 2>/dev/null
        popd >/dev/null 2>&1
      '';
    };
  };
}
