{lib, ...}:
with lib; {
  options.modules.user = {
    password = mkOption {
      description = "The password for the main user. Hashed.";
      type = types.str;
      default = import ../../username.nix;
    };
  };
}
