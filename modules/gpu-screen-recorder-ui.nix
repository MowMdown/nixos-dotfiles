{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.gpu-screen-recorder-ui;
  wrapperDir = "/run/wrappers/bin";
in
{
  options.programs.gpu-screen-recorder-ui = {
    enable = lib.mkEnableOption "gpu-screen-recorder-ui, a ShadowPlay-style overlay for GPU Screen Recorder";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gpu-screen-recorder-ui.override { inherit wrapperDir; };
      defaultText = lib.literalExpression "pkgs.gpu-screen-recorder-ui";
      description = ''
        The gpu-screen-recorder-ui package to use. Overriding wrapperDir is
        handled automatically — only override this if you need a custom build.
      '';
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

    # gsr-global-hotkeys needs cap_setuid so it can grab raw input events
    # for global hotkeys without running as root full-time.
    security.wrappers.gsr-global-hotkeys = {
      source = "${cfg.package}/bin/gsr-global-hotkeys";
      capabilities = "cap_setuid+ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+rx,o+rx";
    };

    # gsr-kms-server needs cap_sys_admin to access KMS/DRM for display capture.
    security.wrappers.gsr-kms-server = {
      source = "${cfg.gpuScreenRecorderPackage}/bin/gsr-kms-server";
      capabilities = "cap_sys_admin+ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+rx,o+rx";
    };
  };
}
