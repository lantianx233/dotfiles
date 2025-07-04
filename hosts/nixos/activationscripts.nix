{
  config,
  pkgs,
  system,
  username,
  ...
}: {
  system.activationScripts.postInstall.text = ''
    echo "->  Running post-install tasks for ${config.users.users.username.name}"
    runuser -l lantianx -c '${pkgs.bash}/bin/bash /home/${username}/dotfiles/scripts/post-install.sh'
  '';
}
