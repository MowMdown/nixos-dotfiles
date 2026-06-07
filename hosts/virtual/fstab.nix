let
  NIX  = "/dev/disk/by-label/NIX";
  EFI  = "/dev/disk/by-label/EFI";
  SWAP = "/dev/disk/by-label/SWAP";
  btrfsOpts = [ "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
in
{
  fileSystems = {
    "/" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "subvol=@" ] ++ btrfsOpts;
    };
    "/home" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ btrfsOpts;
    };
    "/var/tmp" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "subvol=@tmp" ] ++ btrfsOpts;
    };
    "/var/log" = {
      device = NIX;
      fsType = "btrfs";
      options = [ "subvol=@log" ] ++ btrfsOpts;
    };
    "/boot" = {
      device = EFI;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{ device = SWAP; }];
}
