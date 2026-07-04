self:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.rustlog;
  # Import the package from the flake
  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "rustlog-config.json" cfg.settings;
  rustlog = self.packages.${pkgs.system}.rustlog;
in
{
  options.services.rustlog = {
    enable = lib.mkEnableOption "Enable rustlog service.";

    package = lib.mkOption {
      type = lib.types.package;
      default = rustlog;
      description = "The rustlog package to use.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "rustlog";
      description = "User account under which rustlog runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "rustlog";
      description = "Group under which rustlog runs.";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        The settings rustlog should use.

        See [config.dist.json](https://github.com/boring-nick/rustlog/blob/3e4a41a97904d55be2341e5ed93679259a0adbdf/config.dist.json) for a list of all possible options.
      '';
    };
  };

  #   settings = lib.mkOption {
  #     type = lib.types.submodule {
  #       server = lib.mkOption {
  #         type = lib.types.submodule {
  #           enableHttp = lib.mkOption {
  #             type = lib.types.bool;
  #             default = true;
  #             description = "Enables the http server of rustlog";
  #           };
  #           unixSocket = lib.mkOption {
  #             type = lib.types.bool;
  #             default = true;
  #             description = "Unix sockets server";
  #           };
  #           unixSocketPath = lib.mkOption {
  #             type = lib.types.string;
  #             default = "/tmp/http-ytproxy.sock";
  #             description = "Path of the unix socket";
  #           };
  #           host = lib.mkOption {
  #             type = lib.types.string;
  #             default = "0.0.0.0";
  #             description = "Listening address for the HTTP server";
  #           };
  #           port = lib.mkOption {
  #             type = lib.types.int;
  #             default = 8080;
  #             description = "Listening port for the HTTP server";
  #           };
  #         };
  #       };
  #       proxy = lib.mkOption {
  #         type = lib.types.string;
  #         default = "";
  #         description = "Proxy to use for requests for Youtube";
  #       };
  #       httpClientVersion = lib.mkOption {
  #         type = lib.types.int;
  #         default = 1;
  #         description = ''
  #           # The HTTP client version to use for requests to Youtube
  #           # 1: HTTP/1.1
  #           # 2: HTTP/2
  #           # 3: HTTP/3
  #         '';
  #       };

  #       ipv6Only = lib.mkOption {
  #         type = lib.types.bool;
  #         default = false;
  #         description = "Only use IPV6 for requests to Youtube";
  #       };
  #       logLevel = lib.mkOption {
  #         type = lib.types.string;
  #         default = "info";
  #         description = "Log level, can be: trace, debug, info, warn, error, fatal, panic";
  #       };
  #       companion = lib.mkOption {
  #         type = lib.types.submodule {
  #           secretKey = {
  #             type = lib.types.string;
  #             default = "";
  #             description = "16 characters secret key from Invidious Companion";
  #           };
  #         };
  #       };
  #     };
  #     default = { };
  #     description = "The rustlog config";
  #   };
  # };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "rustlog") {
      rustlog = {
        description = "rustlog user";
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "rustlog") {
      rustlog = { };
    };

    systemd.services.rustlog = {
      description = "Twitch logging service inspired by justlog.";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rustlog --config ${settingsFile}";
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
    };
  };
}
