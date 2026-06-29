let
  btrfsOpts = [ "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
  mkSubvol = subvol: mountpoint: {
    inherit mountpoint;
    mountOptions = [ "subvol=/${subvol}" ] ++ btrfsOpts;
  };
in
{
  disko.devices.disk.nvme0n1 = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        EFI = {
          size = "2G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0022" "dmask=0022" "codepage=437"
              "iocharset=ascii" "shortname=mixed" "utf8"
              "errors=remount-ro"
            ];
            extraArgs = [ "-n EFI" ];
          };
        };
        SWAP = {
          size = "16G";
          type = "8200";
          content = {
            type = "swap";
            extraArgs = [ "-L SWAP" ];
          };
        };
        NIX = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-L NIX" "-f" ];
            subvolumes = {
              "@"     = mkSubvol "@"    "/";
              "@nix"  = mkSubvol "@nix" "/nix";
              "@home" = mkSubvol "@home" "/home";
              "@tmp"  = mkSubvol "@tmp"  "/var/tmp";
              "@log"  = mkSubvol "@log"  "/var/log";
            };
          };
        };
      };
    };
  };
}
