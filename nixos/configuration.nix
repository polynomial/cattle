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
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Use the systemd-BOOT EFI Boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only

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
    server=/.ec2.internal/10.1.0.2
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

  #hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

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
    videoDrivers = [ "nvidiaLegacy340" ];
    serverFlagsSection = ''
    Option "DefaultServerLayout" "Layout[all]"
    '';
    serverLayoutSection = ''

    Screen      0  "Screen-nvidia[0]" 0 0
    Screen      1  "Screen1" RightOf "Screen-nvidia[0]"
    Screen      2  "Screen2" LeftOf "Screen-nvidia[0]"
    Screen      3  "Screen3" Above "Screen2"
    Screen      4  "Screen4" Above "Screen1"
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
	'';

	screenSection = ''

    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "metamodes" "DVI-I-1: nvidia-auto-select +0+0"
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
    Option         "metamodes" "nvidia-auto-select +0+0"
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
    Option         "metamodes" "DVI-I-1: nvidia-auto-select +0+0"
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
    Option         "metamodes" "HDMI-0: nvidia-auto-select +0+0"
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
    Option         "metamodes" "HDMI-0: nvidia-auto-select +0+0"
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
