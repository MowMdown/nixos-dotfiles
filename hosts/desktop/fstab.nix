let
  nvme0n1p1 = "/dev/disk/by-uuid/DD83-436F";
  nvme0n1p2 = "/dev/disk/by-uuid/be9582c6-5562-4617-9500-a1d6a6d00ddd";
  nvme1n1p1 = "/dev/disk/by-uuid/bcf7f4cf-647f-46af-835a-7ae162a1972b";
# nvme1n1p2 = "/dev/disk/by-uuid/be9582c6-5562-4617-9500-a1d6a6d00ddd";
  sdb1      = "/dev/disk/by-uuid/7599fa7b-6de7-4d2c-9423-6469e1b9d643";
  btrfsOpts = [ "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
in
{
  fileSystems = {
    "/" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@nixos" ] ++ btrfsOpts;
    };
    "/nix" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@nix-store" ] ++ btrfsOpts;
    };
    "/boot" = {
      device = nvme0n1p1;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
    };
    "/home" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@home" ] ++ btrfsOpts;
    };
    "/home/ryan/.local/share/Steam" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@steam" ] ++ btrfsOpts;
    };
    "/var/tmp" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@tmp" ] ++ btrfsOpts;
    };
    "/var/log" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@log" ] ++ btrfsOpts;
    };
    "/mnt/disk2" = {
      device = sdb1;
      fsType = "btrfs";
      options = btrfsOpts;
    };
  };

  swapDevices = [{ device = nvme1n1p1; }];
}
