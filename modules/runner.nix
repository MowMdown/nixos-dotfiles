{ config, pkgs, lib, ... }:

let
  secrets = import ../../secrets.nix;
in
{
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.forgejo = {
      enable = true;
      name = config.networking.hostName;
      url = "https://git.plexraid.stream"; # replace with your Forgejo URL
      tokenFile = "/etc/forgejo-runner-token";
      labels = [ "nix:host" ];
      settings = {
        runner.capacity = 2;
        cache.enabled = true;
      };
    };
  };

  systemd.services."gitea-runner-forgejo".serviceConfig = {
    EnvironmentFile = lib.mkForce [];
  };

  environment.etc."forgejo-runner-token" = {
    text = secrets.runnerToken;
    mode = "0600";
  };
}
