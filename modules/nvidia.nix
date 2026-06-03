{
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      open = true;
      prime.offload.enable = true;
      prime.nvidiaBusId = "PCI:1@0:0:0";
      prime.amdgpuBusId = "PCI:5@0:0:0";
    };
  };
}