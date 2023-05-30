{ config, ... }: {
  age.secrets.cgm-nightscout-api_secret.file = ../secrets/cgm-nightscout-api_secret.age;

  systemd.services.arion-cgm = {
    wants = [ "network-online.target" "arion-reverse-proxy.service" ];
    after = [ "network-online.target" "arion-reverse-proxy.service" ];
  };

  # based on: https://github.com/nightscout/cgm-remote-monitor/blob/master/docker-compose.yml
  virtualisation.arion.projects.cgm.settings = {
    project.name = "cgm";

    docker-compose.volumes = {
      mongo-db = null;
      mongo-configdb = null;
    };

    networks = {
      dmz = {
        name = "dmz";
        external = true;
      };

      cgm = {
        name = "cgm";
      };
    };

    services = {
      nightscout.service = {
        image = "nightscout/cgm-remote-monitor:14.2.6";
        restart = "unless-stopped";
        depends_on = [
          "mongo"
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

          # AUTH_DEFAULT_ROLES (readable) - possible values readable, denied, or any valid role name.
          # When readable, anyone can view Nightscout without a token. Setting it to denied will require
          # a token from every visit, using status-only will enable api-secret based login.
          AUTH_DEFAULT_ROLES = "readable";

          MONGO_CONNECTION = "mongodb://mongo:27017/nightscout";

          # For all other settings, please refer to the Environment section of the README
          # https://github.com/nightscout/cgm-remote-monitor#environment
        };
        env_file = [
          config.age.secrets.cgm-nightscout-api_secret.path
        ];
        networks = [
          "dmz"
          "cgm"
        ];
      };

      mongo.service = {
        image = "mongo:4.4.21";
        restart = "unless-stopped";
        volumes = [
          "mongo-db:/data/db:cached"
          "mongo-configdb:/data/configdb:cached"
        ];
        networks = [
          "cgm"
        ];
      };
    };
  };
}
