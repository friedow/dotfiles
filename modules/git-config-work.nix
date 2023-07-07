{ ... }: {
  age.secrets.git-config-work = {
    file = ../secrets/git-config-work.age;
    path = "/home/christian/.config/git/user";
    owner = "christian";
    group = "users";
    mode = "600";
  };
}
