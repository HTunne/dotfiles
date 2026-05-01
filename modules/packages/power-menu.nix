{
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.power-menu = pkgs.writeShellApplication {
      name = "power-menu";
      runtimeInputs = [self'.packages.fuzzel];
      text = ''
        choice=$(echo -e "󰐥 Shutdown\n󰗽 Logout\n󰜉 Reboot\n󰌾 Lock" | ${ lib.getExe self'.packages.fuzzel} -l4 -d)
        case ''${choice#* } in
          Shutdown) poweroff;;
          Reboot) reboot;;
          Logout) exit-session;;
          Lock) lock;;
        esac
      '';
    };
  };
}
