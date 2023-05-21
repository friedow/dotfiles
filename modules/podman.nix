{ ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.dnsname.enable = true;
  };

  users.extraUsers.christian.extraGroups = ["podman"];
}