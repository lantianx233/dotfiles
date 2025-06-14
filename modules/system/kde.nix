{
  config,
  pkgs,
  ...
}: {
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "cn";
      variant = "";
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "lantianx";
  };
}
