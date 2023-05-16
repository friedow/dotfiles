{ ... }: {
  systemd.services.arion-reverse-proxy = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
  virtualisation.arion.projects.reverse-proxy.settings = {
    # TODO: name rseolution for https://registry-1.docker.io/v2/ fails inside vm
    project.name = "reverse-proxy";
    services = {
      reverse-proxy.service = {
        image = "traefik:latest";
        restart = "always";
        command = [
          "--providers.docker=true"
          "--providers.docker.exposedbydefault=false"
          "--entrypoints.web.address=:80"
          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entrypoints.websecure.address=:443"
          "--certificatesresolvers.le.acme.httpchallenge=true"
          "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
          "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
          # Change the below to match your email address
          "--certificatesresolvers.le.acme.email=example@example.com"
        ];
        ports = [
          "443:443"
          "80:80"
        ];
        volumes = [
          "./letsencrypt:/letsencrypt"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
      };
    };
  };
}
