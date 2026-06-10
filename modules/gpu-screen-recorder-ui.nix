{ config, lib, pkgs, ... }:
let
  cfg = config.programs.gpu-screen-recorder-ui;
in
{
  options.programs.gpu-screen-recorder-ui = {
    enable = lib.mkEnableOption "gpu-screen-recorder-ui, a ShadowPlay-style overlay for GPU Screen Recorder";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gpu-screen-recorder-ui;
      defaultText = lib.literalExpression "pkgs.gpu-screen-recorder-ui";
      description = "The gpu-screen-recorder-ui package to use.";
    };
    gpuScreenRecorderPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gpu-screen-recorder;
      defaultText = lib.literalExpression "pkgs.gpu-screen-recorder";
      description = "The gpu-screen-recorder package to use for gsr-kms-server.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.gsr-global-hotkeys = {
      source = "${cfg.package}/bin/gsr-global-hotkeys";
      capabilities = "cap_setuid+ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+rx,o+rx";
    };

    security.wrappers.gsr-kms-server = {
      source = "${cfg.gpuScreenRecorderPackage}/bin/gsr-kms-server";
      capabilities = "cap_sys_admin+ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+rx,o+rx";
    };
  };
  meta.maintainers = with lib.maintainers; [
    mowmdown
  ];
}