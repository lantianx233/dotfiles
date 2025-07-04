# 💫 https://github.com/JaKooLit 💫 #
{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers."nvidia-prime";
in {
  options.drivers.nvidia-prime = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Offload";
    intelBusId = mkOption {
      type = types.str;
      default = "";
    };
    amdgpuBusId = mkOption {
      type = types.str;
      default = "PCI:6:0:0";
    };
    nvidiaBusId = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "${cfg.intelBusId}";
        amdgpuBusId = "${cfg.amdgpuBusId}";
        nvidiaBusId = "${cfg.nvidiaBusId}";
      };
    };
  };
}
