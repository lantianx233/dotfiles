{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nixos
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    #media-session.enable = true;
  };

  # services.xserver.libinput.enable = true;

  users.users.lantianx = {
    isNormalUser = true;
    description = "lantianx";
    extraGroups = ["networkmanager" "wheel" "kvm" "adbusers"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  programs.adb.enable = true;

  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    #defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    inputs.alejandra.defaultPackage."${system}"
    android-tools
    payload-dumper-go
    git-repo
    ventoy-full
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = lib.mkForce ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
      download-buffer-size = 524288000;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    wqy_zenhei
    maple-mono.NF-CN-unhinted
  ];

  #  services.dae = {
  #    enable = true;
  #    configFile = "/home/lantianx/dae/config.dae";
  #    assets = with pkgs; [
  #      v2ray-geoip
  #      v2ray-domain-list-community
  #    ];
  #  };

  services.daed = {
    enable = true;

    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  system.stateVersion = "25.05";
}
