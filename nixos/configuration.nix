# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  vars = import ./vars.nix { inherit pkgs; };

in {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "16.09";


  imports =
    [
      ./hardware-configuration.nix
      ./security-keys.nix
      ./vpn/extole.nix
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

  networking.hostName = vars.hostName;

  # Extole Development (should be moved to extole.nix)
  #virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.headless = true;
  services.grafana = {
    enable = true;
    security.adminPassword = "foob4r";
  };

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  services.sshd.enable = true;
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

  networking.wireless.enable = false;
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
    #videoDrivers = [ "intel" ];

    multitouch.enable = true;
    multitouch.invertScroll = true;
    multitouch.ignorePalm = true;

    #synaptics.enable = false;
    #synaptics.tapButtons = false;
    #synaptics.twoFingerScroll = true;
    #synaptics.palmDetect = true;
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
