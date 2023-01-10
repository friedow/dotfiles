{ config, lib, pkgs, ... }: {
    options.hm = lib.mkOption {
        type = lib.types.unspecified;
        default = {};
    };
    config.home-manager.users.christian = config.hm;
}
