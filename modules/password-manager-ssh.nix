{ ... }: {
  home-manager.users.christian.programs.ssh = {
    extraConfig = "IdentityAgent ~/.1password/agent.sock";
  };
}