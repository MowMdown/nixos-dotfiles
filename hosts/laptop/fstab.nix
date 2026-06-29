let
  nvme0n1p1  = "/dev/disk/by-uuid/E8A3-3B13";
  nvme0n1p2 = "/dev/disk/by-uuid/a0520dea-e69d-491f-9177-6bd559f1f567";
  nvme0n1p3  = "/dev/disk/by-uuid/41c61953-53d0-49b0-b928-409be7629a6a";
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
  };

  swapDevices = [{ device = nvme0n1p2; }];
}
