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
      #./security-keys.nix
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

  # minecraft silliness
  #hardware.opengl.driSupport32Bit = true;
  #hardware.pulseaudio.support32Bit = true;
  #hardware.pulseaudio.enable = true;
  #services.teamspeak3.enable = true;

  #hardware.pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };

  services.grafana.enable = true;
  services.netdata.enable = true;
  services.netdata.configText = ''
[backend]
	enabled = yes
	type = graphite
	destination = localhost
	data source = as collected
	prefix = netdata
  '';

  # Use the systemd-BOOT EFI Boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
#  boot.loader.grub.enable = true;
#  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.dhcpcd = {
    enable = true;
    extraConfig = ''
      duid
      waitip 6
      #ipv6only
    '';
  };
  networking.enableIPv6 = true;
  networking.hostName = vars.hostName;

#services.redshift.enable = true;
#services.redshift.latitude = "37.6795894";
#services.redshift.longitude = "-122.4063549";
#services.redshift.brightness.night = "0.5";

  # Extole Development (should be moved to extole.nix)
  users.extraGroups.vboxusers.members = [ "bsmith" ];
  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.headless = true;
#
virtualisation.docker.enable = true;
#
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  services.keybase.enable = true;
  services.kbfs.enable = true;


  services.tomcat.enable = true;

  services.dnsmasq.enable = true;
  services.dnsmasq.extraConfig = ''
    conf-dir=/etc/dnsmasq.d
    server=/.ec2.internal/10.1.0.2
    server=/.intole.net/10.1.0.2
  '';
#  networking.extraHosts = ''
#  '';
  services.nfs.server.exports = ''
    /home/bsmith/.pr 10.4.1.100(ro)
    /home/bsmith/src/extole/tech 10.11.14.16(rw,no_subtree_check,all_squash,anonuid=1000,anongid=100,async,insecure)
  '';

  #networking.wireless.enable = true;
  #networking.wireless.userControlled.enable = true;
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

  #hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  powerManagement.enable = true;
  services.upower.enable = true;
  services.nfs.server.enable = true;

  services.tlp.enable = false;
  nixpkgs.config = {

    allowUnfree = true;

  #  config.firefox.enableGoogleTalkPlugin = true;
  #  config.firefox.enableAdobeFlash = true;
  #  chromium.enablePepperFlash = true;
  #  chromium.enablePepperPDF = true;

  };


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = vars.layout;
    windowManager.default = "awesome";
    windowManager.awesome.enable = true;
    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    videoDrivers = [ "nvidiaLegacy340" ];
    serverFlagsSection = ''
    Option "DefaultServerLayout" "Layout[all]"
    '';
    serverLayoutSection = ''
    Screen      0  "Screen-nvidia[0]" 923 1200
    Screen      1  "Screen1" 1920 0
    Screen      2  "Screen2" 2843 1200
    Screen      3  "Screen3" 4763 1200
    Screen      4  "Screen4" 3840 0
    Screen      5  "Screen5" 0 120
    Option         "Xinerama" "0"
EndSection

Section "ServerLayout"
    Identifier "NoOverRidesAreLame"
    '';
    monitorSection = ''
    VendorName     "Unknown"
    ModelName      "Samsung SyncMaster"
    HorizSync       30.0 - 81.0
    VertRefresh     56.0 - 60.0
    Option         "DPMS"
EndSection

Section "Monitor"
    # HorizSync source: unknown, VertRefresh source: unknown
    Identifier     "Monitor1"
    VendorName     "Unknown"
    ModelName      "Samsung SyncMaster"
    HorizSync       0.0 - 0.0
    VertRefresh     0.0
    Option         "DPMS"
EndSection

Section "Monitor"
    # HorizSync source: unknown, VertRefresh source: unknown
    Identifier     "Monitor2"
    VendorName     "Unknown"
    ModelName      "Samsung SyncMaster"
    HorizSync       0.0 - 0.0
    VertRefresh     0.0
    Option         "DPMS"
EndSection

Section "Monitor"
    # HorizSync source: unknown, VertRefresh source: unknown
    Identifier     "Monitor3"
    VendorName     "Unknown"
    ModelName      "Samsung SyncMaster"
    HorizSync       0.0 - 0.0
    VertRefresh     0.0
    Option         "DPMS"
EndSection

Section "Monitor"
    # HorizSync source: edid, VertRefresh source: edid
    Identifier     "Monitor4"
    VendorName     "Unknown"
    ModelName      "Samsung SyncMaster"
    HorizSync       30.0 - 81.0
    VertRefresh     56.0 - 60.0
    Option         "DPMS"
EndSection

Section "Monitor"
    # HorizSync source: edid, VertRefresh source: edid
    Identifier     "Monitor5"
    VendorName     "Unknown"
    ModelName      "Dell G2410"
    #HorizSync       30.0 - 81.0
    #VertRefresh     56.0 - 60.0
    Option         "DPMS"
	'';
    deviceSection = ''
    
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 210"
    BusID          "PCI:6:0:0"
    Screen          0
EndSection

Section "Device"
    Identifier     "Device1"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 210"
    BusID          "PCI:4:0:0"
EndSection

Section "Device"
    Identifier     "Device2"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 210"
    BusID          "PCI:5:0:0"
    Screen          0
EndSection

Section "Device"
    Identifier     "Device3"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 210"
    BusID          "PCI:5:0:0"
    Screen          1
EndSection

Section "Device"
    Identifier     "Device4"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 210"
    BusID          "PCI:6:0:0"
    Screen          1
EndSection

Section "Device"
    Identifier     "Device5"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 210"
    BusID          "PCI:4:0:0"
    Screen          1
	'';

	screenSection = ''

    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

Section "Screen"
    Identifier     "Screen1"
    Device         "Device1"
    Monitor        "Monitor1"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

Section "Screen"
    Identifier     "Screen2"
    Device         "Device2"
    Monitor        "Monitor2"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

Section "Screen"
    Identifier     "Screen3"
    Device         "Device3"
    Monitor        "Monitor3"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

Section "Screen"
    Identifier     "Screen4"
    Device         "Device4"
    Monitor        "Monitor4"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

Section "Screen"
    Identifier     "Screen5"
    Device         "Device5"
    Monitor        "Monitor5"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "metamodes" "HDMI-0: nvidia-auto-select +0+0 {rotation=invert}; HDMI-0: 1280x1024 +0+0 {rotation=invert}; HDMI-0: 1280x1024_60 +0+0 {rotation=invert}; HDMI-0: 1152x864 +0+0 {rotation=invert}; HDMI-0: 1024x768 +0+0 {rotation=invert}; HDMI-0: 1024x768_60 +0+0 {rotation=invert}; HDMI-0: 800x600 +0+0 {rotation=invert}; HDMI-0: 800x600_60 +0+0 {rotation=invert}; HDMI-0: 640x480 +0+0 {rotation=invert}; HDMI-0: 640x480_60 +0+0 {rotation=invert}; HDMI-0: nvidia-auto-select +0+0 {rotation=invert, viewportin=1680x1050, viewportout=1728x1080+96+0}; HDMI-0: nvidia-auto-select +0+0 {rotation=invert, viewportin=1440x900, viewportout=1728x1080+96+0}; HDMI-0: nvidia-auto-select +0+0 {rotation=invert, viewportin=1366x768, viewportout=1920x1079+0+0}; HDMI-0: nvidia-auto-select +0+0 {rotation=invert, viewportin=1280x800, viewportout=1728x1080+96+0}; HDMI-0: nvidia-auto-select +0+0 {rotation=invert, viewportin=1280x720}"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
	'';


  };

  services.openssh.enable = true;
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
  #security.pam.loginLimits = { domain = "bsmith"; item = "

  programs.adb.enable = true;
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
