{
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    graphics.enable = true;

    nvidia.open = true;
    nvidia.prime = {
      offload.enable = true;
      nvidiaBusId = "PCI:1@0:0:0";
      amdgpuBusId = "PCI:5@0:0:0";
    };
  };
}