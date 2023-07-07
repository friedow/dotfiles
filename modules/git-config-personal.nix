{ ... }: {
  age.secrets.git-config-personal = {
    file = ../secrets/git-config-personal.age;
    path = "/home/christian/.config/git/user";
    owner = "christian";
    group = "users";
    mode = "600";
  };
}
