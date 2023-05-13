{ ... }: {
  virtualisation.arion.projects = {
    nightscout = {
      project.name = "nightscout";
      services = {
        nightscout.service = {
          image = "nightscout/cgm-remote-monitor:latest";
          restart = "always";
          depends_on = [
            "nightscout-db"
          ];
          labels = {
            "traefik.enable" = "true";
            # TODO: Change the below Host from `localhost` to be the web address where Nightscout is running.
            "traefik.http.routers.nightscout.rule" = "Host(`localhost`)";
            "traefik.http.routers.nightscout.entrypoints" = "websecure";
            "traefik.http.routers.nightscout.tls.certresolver" = "le";
          };
          environment = {
            ### Variables for the container
            NODE_ENV = "production";
            TZ = "Etc/UTC";

            ### Overridden variables for Docker Compose setup
            # The `nightscout` service can use HTTP, because we use `traefik` to serve the HTTPS
            # and manage TLS certificates
            INSECURE_USE_HTTP = "true";

            # For all other settings, please refer to the Environment section of the README
            ### Required variables
            # MONGO_CONNECTION - The connection string for your Mongo database.
            # Something like mongodb://sally:sallypass@ds099999.mongolab.com:99999/nightscout
            # The default connects to the `mongo` included in this docker-compose file.
            # If you change it, you probably also want to comment out the entire `mongo` service block
            # and `depends_on` block above.
            MONGO_CONNECTION = "mongodb://nightscout-db:27017/nightscout";

            # API_SECRET - A secret passphrase that must be at least 12 characters long.
            API_SECRET = "change_me";

            ### Features
            # ENABLE - Used to enable optional features, expects a space delimited list, such as: careportal rawbg iob
            # See https://github.com/nightscout/cgm-remote-monitor#plugins for details
            ENABLE = "careportal rawbg iob";

            # AUTH_DEFAULT_ROLES (readable) - possible values readable, denied, or any valid role name.
            # When readable, anyone can view Nightscout without a token. Setting it to denied will require
            # a token from every visit, using status-only will enable api-secret based login.
            AUTH_DEFAULT_ROLES = "denied";

            # For all other settings, please refer to the Environment section of the README
            # https://github.com/nightscout/cgm-remote-monitor#environment
          };
        };

        nightscout.service = {
          image = "mongo:4.4";
          restart = "always";
          volumes = [
            "./nightscout-data:/data/db:cached"
          ];
        };
      };
    };
  };
}
