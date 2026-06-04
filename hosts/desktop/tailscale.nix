{ config, pkgs, ... }:

{
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  services.networkd-dispatcher = {
    enable = true;

    rules."50-tailscale-optimizations" = {
      onState = [ "routable" ];
      script = "${pkgs.ethtool}/bin/ethtool -K wlp6s0 rx-udp-gro-forwarding on rx-gro-list off";
    };
  };
}