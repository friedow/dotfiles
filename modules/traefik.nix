{ ... }: {
  virtualisation.arion.projects = {
    # TODO: add traefik service

    reverse-proxy = {
      project.name = "reverse-proxy";
      services = {
        reverse-proxy.service = {
          image = "";
          restart = "unless-stopped";
          environment = { POSTGRESS_PASSWORD = "password"; };    
        };
      };
    };
  };
}
