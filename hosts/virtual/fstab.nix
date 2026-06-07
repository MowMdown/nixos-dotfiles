let
  NIX  = "/dev/disk/by-label/NIX";
  EFI  = "/dev/disk/by-label/EFI";
  SWAP = "/dev/disk/by-label/SWAP";
in
{
  fileSystems = {
    "/" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@" ];
    };

    "/home" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@home" ];
    };

    "/var/tmp" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@tmp" ];
    };

    "/var/log" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@log" ];
    };

    "/boot" = {
      device = EFI;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{ device = SWAP; }];
}
