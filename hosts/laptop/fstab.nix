let
  nvme0n1p1  = "/dev/disk/by-label/EFI";
  nvme0n1p2 = "/dev/disk/by-label/SWAP";
  nvme0n1p3  = "/dev/disk/by-label/NIX";
  btrfsOpts = [ "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
in
{
  fileSystems = {
    "/" = {
      device = nvme0n1p3;
      fsType = "btrfs";
      options = [ "subvol=/@" ] ++ btrfsOpts;
    };
    "/nix" = {
      device = nvme0n1p3;
      fsType = "btrfs";
      options = [ "subvol=/@nix" ] ++ btrfsOpts;
    };
    "/boot" = {
      device = nvme0n1p1;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
    };
    "/home" = {
      device = nvme0n1p3;
      fsType = "btrfs";
      options = [ "subvol=/@home" ] ++ btrfsOpts;
    };
    "/var/tmp" = {
      device = nvme0n1p3;
      fsType = "btrfs";
      options = [ "subvol=/@tmp" ] ++ btrfsOpts;
    };
    "/var/log" = {
      device = nvme0n1p3;
      fsType = "btrfs";
      options = [ "subvol=/@log" ] ++ btrfsOpts;
    };

  swapDevices = [{ device = nvme0n1p2; }];
}
