{ config, ... }: {
  age.secrets.nightscout-api-secret.file = ../secrets/nightscout-api-secret.age;

  virtualisation.arion.projects.nightscout.settings = {
    project.name = "nightscout";

    docker-compose.volumes = {
      nightscout-data = null;
      mongo-configdb = null;
    };

    networks = {
      dmz = {
        name = "dmz";
        external = true;
      };

      nightscout = {
        name = "nightscout";
      };
    };

    services = {
      nightscout.service = {
        image = "nightscout/cgm-remote-monitor:14.2.6";
        restart = "always";
        depends_on = [
          "nightscout-db"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.docker.network" = "dmz";
          "traefik.http.routers.nightscout.rule" = "Host(`nightscout.friedow.com`)";
          "traefik.http.routers.nightscout.entrypoints" = "websecure";
          "traefik.http.routers.nightscout.tls.certresolver" = "le";
        };
        environment = {
          ### Variables for the container
          NODE_ENV = "production";
          TZ = "Etc/UTC";
          LANGUAGE = "de";
          TIME_FORMAT = "24";
          EDIT_MODE = "off";

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

          # AUTH_DEFAULT_ROLES (readable) - possible values readable, denied, or any valid role name.
          # When readable, anyone can view Nightscout without a token. Setting it to denied will require
          # a token from every visit, using status-only will enable api-secret based login.
          AUTH_DEFAULT_ROLES = "readable";

          # For all other settings, please refer to the Environment section of the README
          # https://github.com/nightscout/cgm-remote-monitor#environment
        };
        env_file = [
          config.age.secrets.nightscout-api-secret.path
        ];
        networks = [
          "dmz"
          "nightscout"
        ];
      };

      nightscout-db.service = {
        image = "mongo:4.4.21";
        restart = "always";
        volumes = [
          "nightscout-data:/data/db:cached"
          "mongo-configdb:/data/configdb:cached"
        ];
        networks = [
          "nightscout"
        ];
      };
    };
  };
}
