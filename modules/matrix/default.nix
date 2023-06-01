{ config, pkgs, ... }: {
  age.secrets.matrix-postgres-postgres_user.file = ../../secrets/matrix-postgres-postgres_user.age;
  age.secrets.matrix-postgres-postgres_password.file = ../../secrets/matrix-postgres-postgres_password.age;
  age.secrets.matrix-synapse-registration_shared_secret.file = ../../secrets/matrix-synapse-registration_shared_secret.age;
  age.secrets.matrix-synapse-macaroon_secret_key.file = ../../secrets/matrix-synapse-macaroon_secret_key.age;
  age.secrets.matrix-synapse-form_secret.file = ../../secrets/matrix-synapse-form_secret.age;

  age.secrets.matrix-synapse-signing_key.file = ../../secrets/matrix-synapse-signing_key.age;

  age.secrets.env-matrix-postgres-postgres_user.file = ../../secrets/env-matrix-postgres-postgres_user.age;
  age.secrets.env-matrix-postgres-postgres_password.file = ../../secrets/env-matrix-postgres-postgres_password.age;

  system.activationScripts."matrix-synapse-homeserver_yaml-secrets" = ''
    matrix_postgres_postgres_user=`cat "${config.age.secrets.matrix-postgres-postgres_user.path}"`
    matrix_postgres_postgres_password=$(cat "${config.age.secrets.matrix-postgres-postgres_password.path}")
    matrix_synapse_registration_shared_secret=$(cat "${config.age.secrets.matrix-synapse-registration_shared_secret.path}")
    matrix_synapse_macaroon_secret_key=$(cat "${config.age.secrets.matrix-synapse-macaroon_secret_key.path}")
    matrix_synapse_form_secret=$(cat "${config.age.secrets.matrix-synapse-form_secret.path}")
    configFile=/etc/matrix/homeserver.yaml
    ${pkgs.gnused}/bin/sed -i "s#@matrix-postgres-postgres_user@#$matrix_postgres_postgres_user#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-postgres-postgres_password@#$matrix_postgres_postgres_password#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-registration_shared_secret@#$matrix_synapse_registration_shared_secret#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-macaroon_secret_key@#$matrix_synapse_macaroon_secret_key#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-form_secret@#$matrix_synapse_form_secret#" "$configFile"
  '';

  system.activationScripts."matrix-synapse-signing_key-secrets" = ''
    matrix_synapse_signing_key=`cat "${config.age.secrets.matrix-synapse-signing_key.path}"`
    configFile=/etc/matrix/friedow.com.signing.key
    ${pkgs.gnused}/bin/sed -i "s#@matrix-synapse-signing_key@#$matrix_synapse_signing_key#" "$configFile"
  '';

  systemd.services.arion-matrix = {
    wants = [ "network-online.target" "arion-reverse-proxy.service" ];
    after = [ "network-online.target" "arion-reverse-proxy.service" ];
  };

  environment.etc."matrix/homeserver.yaml" = {
    source = ./homeserver.yaml;
    mode = "0666";
  };

  environment.etc."matrix/friedow.com.signing.key" = {
    source = ./friedow.com.signing.key;
    mode = "0666";
  };

  environment.etc."matrix/friedow.com.log.config" = {
    source = ./friedow.com.log.config;
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
        image = "docker.io/matrixdotorg/synapse:v1.84.1";
        restart = "unless-stopped";
        depends_on = [
          "postgres"
        ];
        environment = {
          SYNAPSE_CONFIG_PATH = "/config/homeserver.yaml";
        };
        volumes = [
          # TODO: chown -R 991:991 /var/lib/docker/volumes/matrix_synapse-data/_data
          # is necessary to fix permission issues within the synapse container
          "synapse-data:/data"
          "/etc/matrix/homeserver.yaml:/config/homeserver.yaml"
          "/etc/matrix/friedow.com.signing.key:/config/friedow.com.signing.key"
          "/etc/matrix/friedow.com.log.config:/config/friedow.com.log.config"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.synapse.rule" = "Host(`matrix.friedow.com`)";
          "traefik.http.routers.synapse.entrypoints" = "websecure";
          "traefik.http.routers.synapse.tls.certresolver" = "le";
        };
        networks = [
          "dmz"
          "matrix"
        ];
      };

      postgres.service = {
        image = "docker.io/postgres:15.3-alpine";
        restart = "unless-stopped";
        environment = {
          POSTGRES_DB = "synapse";
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
