{ pkgs, ... }: {
  home-manager.users.christian.home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.pubsub-emulator
    ])
    kubectl
  ];
}
