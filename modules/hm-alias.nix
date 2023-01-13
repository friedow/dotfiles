{ config, lib, pkgs, ... }: {
    # Does not work, because it has the wrong type.
    # Needs the home manager type to work.
    # options.hm = lib.mkOption {
    #     type = lib.types.unspecified;
    #     default = {};
    # };
    # config.home-manager.users.christian = config.hm;
}
