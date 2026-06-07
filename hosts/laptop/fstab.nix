let
  nvme0n1p1 = "/dev/disk/by-uuid/217E-C306";
  nvme0n1p2 = "/dev/disk/by-uuid/1dd2e967-e85d-43cd-a61b-e48ffa8ff450";
  btrfsOpts = [ "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
in
{
  fileSystems = {
    "/" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=@nixos" ] ++ btrfsOpts;
    };
    "/home" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ btrfsOpts;
    };
    "/swap" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=@swap" "nodatacow" "noatime" ];
    };
    "/boot" = {
      device = nvme0n1p1;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{ device = "/swap/swapfile"; size = 16384; }];
}
