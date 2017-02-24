# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  vars = import ./vars.nix { inherit pkgs; };

in {
  imports =
    [
      ./hardware-configuration.nix
      ./security-keys.nix
      ./vpn/extole.nix
      ./vpn/pia.nix
    ];

  services.autofs = {
    enable = true;
    autoMaster = ''
      /a file,sun:/etc/autohuugs
    '';
  };
  environment.etc."autohuugs".text = ''
      huugs	-ro,soft,intr	10.4.1.1:/huugs
  '';

  # grafana testing
  services.grafana = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    httpConfig = ''
    default_type                 application/octet-stream;
    map_hash_bucket_size         1024;
    map_hash_max_size            102400;
    variables_hash_bucket_size   1024;
    variables_hash_max_size      102400;
    client_max_body_size         100M;
    server_tokens                off; # hide the version
    sendfile                     on;
    keepalive_timeout            65;
    gzip                         on;
    gzip_proxied                 any;
    set_real_ip_from             10.0.0.0/8;      #  Amazon AWS internal
    set_real_ip_from             127.0.0.1; # local development
    real_ip_header               X-Forwarded-For;
    real_ip_recursive            on;
    resolver                     172.16.0.23 valid=5m;
    resolver_timeout             60s;
    # currently this breaks login
    #proxy_http_version          1.1;
    proxy_connect_timeout        1;
    proxy_send_timeout           5;
    proxy_read_timeout           305;


    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent $request_time "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" "$scheme://$host$uri"';

    log_format detailed 'status=$status ^ request_time=$request_time ^ upstream_response_time=$upstream_response_time ^ '
                        'pipe=$pipe ^ bytes_sent=$bytes_sent ^ connection=$connection ^ remote_addr=$remote_addr ^ '
                        'x_forwarded_for=$http_x_forwarded_for ^ host=$host ^ time=$time_iso8601 ^ request=$request ^ '
                        'cookie_ex_id=$cookie_ex_id ^ cookie_access_token=$cookie_access_token ^ http_Authorization=$http_Authorization ^ '
                        'http_referer=$http_referer ^ http_user_agent=$http_user_agent ^ '
                        'upstream_addr=$upstream_addr ^ http_X-Extole-Polling-Time=$http_X_Extole_Polling_Time';

    error_log  syslog:server=127.0.0.1 warn;
    access_log syslog:server=127.0.0.1,facility=local6,tag=nginx,severity=info detailed;


    gzip_types text/plain text/css text/xml application/xml text/javascript
               application/x-javascript application/json application/xml+rss
               image/svg+xml application/vnd.ms-fontobject application/x-font-ttf
               font/opentype font/x-woff image/gif image/jpeg image/png image/tiff;



      upstream client {
        keepalive 100;
        server client-0.qa.intole.net:8080 max_fails=10 fail_timeout=10s;
        server client-1.qa.intole.net:8080 max_fails=10 fail_timeout=10s;
        server client-2.qa.intole.net:8080 max_fails=10 fail_timeout=10s;
      }
      server {
        listen 80;
    access_log syslog:server=127.0.0.1,facility=local6,severity=info,tag=nginx_client_access  detailed;
    error_log syslog:server=127.0.0.1,facility=local6,severity=error,tag=nginx_client_error info;
        location /appboot/status {
          stub_status on;
          allow 10.0.0.0/8;
          allow 127.0.0.0/8;
          deny all;
        }
        location / {
          proxy_pass http://client;
        }
      }
'';
};

  # minecraft silliness
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Use the systemd-boot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = vars.hostName;

  # Extole Development (should be moved to extole.nix)
  users.extraGroups.vboxusers.members = [ "bsmith" ];
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.headless = true;
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  services.dnsmasq.enable = true;
  services.dnsmasq.extraConfig = ''
    address=/.lo.intole.net/127.0.0.1
    address=/.lo.extole.io/10.11.14.16
    address=/.lo.vokate.com/10.11.14.16
    address=/my-lo.extole.com/10.11.14.16
    address=/tags-lo.extole.com/10.11.14.16
    server=/.intole.net/10.1.0.2
  '';
#  networking.extraHosts = ''
#  '';
  services.nfs.server.exports = ''
    /home/bsmith/src/extole/tech 10.11.14.16(rw,no_subtree_check,all_squash,anonuid=1000,anongid=100,async,insecure)
  '';

  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.firewall.enable = false;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = vars.timeZone;

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = vars.systemPackages;

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  powerManagement.enable = true;
  services.upower.enable = true;
  services.nfs.server.enable = true;

  services.tlp.enable = false;
  nixpkgs.config = {

    allowUnfree = true;

    config.firefox.enableGoogleTalkPlugin = true;
    config.firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

  };


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = vars.layout;
    windowManager.default = "awesome";
    windowManager.awesome.enable = true;
    desktopManager.default = "none";
    desktopManager.xterm.enable = false;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    videoDrivers = [ "intel" ];

    multitouch.enable = true;
    multitouch.invertScroll = true;
    multitouch.ignorePalm = true;

    synaptics.enable = false;
    synaptics.tapButtons = false;
    synaptics.twoFingerScroll = true;
    synaptics.palmDetect = true;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers."${vars.username}" = {
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" "audio" "video" "systemd-journal" "systemd-network" ];
  };

  #system.stateVersion = "16.03";
}
