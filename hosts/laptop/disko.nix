let
  mkSubvol = { subvol, mountpoint, extraOpts ? [] }: {
    inherit mountpoint;
    mountOptions = [
      "compress=zstd:3"
      "noatime"
      "discard=async"
      "space_cache=v2"
    ] ++ extraOpts;
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
        ROOT = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-L ROOT" "-f" ];
            subvolumes = {
              "@"     = mkSubvol { subvol = "@";     mountpoint = "/";        }; #extraOpts = [ ]; };
              "@nix"  = mkSubvol { subvol = "@nix";  mountpoint = "/nix";     }; #extraOpts = [ ]; };
              "@home" = mkSubvol { subvol = "@home"; mountpoint = "/home";    }; #extraOpts = [ ]; };
              "@tmp"  = mkSubvol { subvol = "@tmp";  mountpoint = "/var/tmp"; }; #extraOpts = [ ]; };
              "@log"  = mkSubvol { subvol = "@log";  mountpoint = "/var/log"; }; #extraOpts = [ ]; };
            };
          };
        };
      };
    };
  };
}
