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
  disko.devices = {
    disk.nvme0n1 = {
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
          ROOT = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-L ROOT" "-d raid0" "-m raid0" "/dev/nvme1n1p2" "-f" ];
              subvolumes = {
                "@nixos"     = mkSubvol { subvol = "@nixos";     mountpoint = "/";     }; #extraOpts = [ ]; };
                "@nix-store" = mkSubvol { subvol = "@nix-store"; mountpoint = "/nix";  }; #extraOpts = [ ]; };
                "@home"      = mkSubvol { subvol = "@home";      mountpoint = "/home"; }; #extraOpts = [ ]; };
                "@steam"     = mkSubvol { subvol = "@steam";     mountpoint = "/home/ryan/.local/share/Steam"; }; #extraOpts = [ ]; };
                "@tmp"       = mkSubvol { subvol = "@tmp";       mountpoint = "/var/tmp"; }; #extraOpts = [ ]; };
                "@log"       = mkSubvol { subvol = "@log";       mountpoint = "/var/log"; }; #extraOpts = [ ]; };
              };
            };
          };
        };
      };
    };
    disk.nvme1n1 = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "gpt";
        partitions = {
          SWAP = {
            size = "24G";
            type = "8200";
            content = {
              type = "swap";
              extraArgs = [ "-L SWAP" ];
            };
          };
          ROOT_MEMBER = {
            size = "100%";
          };
        };
      };
    };
  };
}
