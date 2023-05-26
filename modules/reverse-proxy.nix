{ ... }: {
  systemd.services.arion-reverse-proxy = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

  virtualisation.arion.projects.reverse-proxy.settings = {
    project.name = "reverse-proxy";

    docker-compose.volumes = {
      letsencrypt-data = null;
    };

    networks.dmz.name = "dmz";

    services = {
      reverse-proxy.service = {
        image = "traefik:v2.10.1";
        command = [
          "--providers.docker=true"
          "--providers.docker.exposedbydefault=false"
          "--entrypoints.web.address=:80"
          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entrypoints.websecure.address=:443"
          "--certificatesresolvers.le.acme.httpchallenge=true"
          "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
          "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
          "--certificatesresolvers.le.acme.email=webmaster@friedow.com"
        ];
        ports = [
          "443:443"
          "80:80"
        ];
        volumes = [
          "letsencrypt-data:/letsencrypt"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        restart = "always";
        networks = [
          "dmz"
        ];
      };
    };
  };
}
