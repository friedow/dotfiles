{ config, ... }: {
  age.secrets.matrix-postgres-postgres_user.file = ../secrets/matrix-postgres-postgres_user.age;
  age.secrets.matrix-postgres-postgres_password.file = ../secrets/matrix-postgres-postgres_password.age;
  age.secrets.matrix-synapse-registration_shared_secret.file = ../secrets/matrix-synapse-registration_shared_secret.age;
  age.secrets.matrix-synapse-macaroon_secret_key.file = ../secrets/matrix-synapse-macaroon_secret_key.age;
  age.secrets.matrix-synapse-form_secret.file = ../secrets/matrix-synapse-form_secret.age;


  age.secrets.env-matrix-postgres-postgres_user.file = ../secrets/env-matrix-postgres-postgres_user.age;
  age.secrets.env-matrix-postgres-postgres_password.file = ../secrets/env-matrix-postgres-postgres_password.age;

  system.activationScripts."matrix-synapse-homeserver_yml-secrets" = ''
    matrix-postgres-postgres_user=$(cat "${config.age.secrets.matrix-postgres-postgres_user.path}")
    matrix-postgres-postgres_password=$(cat "${config.age.secrets.matrix-postgres-postgres_password.path}")
    matrix-synapse-registration_shared_secret=$(cat "${config.age.matrix-synapse-registration_shared_secret.path}")
    matrix-synapse-macaroon_secret_key=$(cat "${config.age.secrets.matrix-synapse-macaroon_secret_key.path}")
    matrix-synapse-form_secret=$(cat "${config.age.secrets.matrix-synapse-form_secret.path}")
    configFile=/etc/matrix/homeserver.yml
    ${pkgs.gnused}/bin/sed -i "s#@matrix-postgres-postgres_user@#$matrix-postgres-postgres_user#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-postgres-postgres_password@#$matrix-postgres-postgres_password#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-registration_shared_secret@#$matrix-synapse-registration_shared_secret#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-macaroon_secret_key@#$matrix-synapse-macaroon_secret_key#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-form_secret@#$matrix-synapse-form_secret#" "$configFile"
  '';

  systemd.services.arion-cgm = {
    wants = [ "network-online.target" "arion-reverse-proxy.service" ];
    after = [ "network-online.target" "arion-reverse-proxy.service" ];
  };

  environment.etc."matrix/homeserver.yml" = {
    source = ./homeserver.yml;
    mode = "0666";
  };

  # based on: https://github.com/matrix-org/synapse/blob/develop/contrib/docker/docker-compose.yml
  virtualisation.arion.projects.matrix.settings = {
    project.name = "matrix";

    docker-compose.volumes = {
      synapse-data = null;
      postgres-data = null;
    };

    networks = {
      dmz = {
        name = "dmz";
        external = true;
      };

      matrix = {
        name = "matrix";
      };
    };

    services = {
      synapse.service = {
        image = "docker.io/matrixdotorg/synapse:latest";
        restart = "unless-stopped";
        depends_on = [
          "postgres"
        ];
        volumes = [
          "synapse-data:/data"
          "/etc/matrix/homeserver.yaml:/data/homeserver.yaml"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.docker.network" = "dmz";
          "traefik.http.routers.nightscout.rule" = "Host(`matrix.friedow.com`)";
          "traefik.http.routers.nightscout.entrypoints" = "websecure";
          "traefik.http.routers.nightscout.tls.certresolver" = "le";
        };
        networks = [
          "dmz"
          "matrix"
        ];
      };

      postgres.service = {
        image = "docker.io/postgres:15.3-alpine";
        restart = "always";
        environment = {
          POSTGRES_INITDB_ARGS = "--encoding=UTF-8 --lc-collate=C --lc-ctype=C";
        };
        env_file = [
          config.age.secrets.env-matrix-postgres-postgres_user.path
          config.age.secrets.env-matrix-postgres-postgres_password.path
        ];
        volumes = [
          "postgres-data:/var/lib/postgresql/data"
        ];
        networks = [
          "matrix"
        ];
      };
    };
  };
}
