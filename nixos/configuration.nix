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
    ];
  nixpkgs.config.allowUnfree = true;
virtualisation.virtualbox.host.enable = true;

  services.rpcbind.enable = true;
  services.nfs.server = {
    enable = true;
    exports = ''
      /home/bsmith/src/extole/tech 10.0.0.0/8(rw,all_squash,anonuid=1000,anongid=100)
    '';
  };

  # Use the systemd-boot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages_4_6;


  networking.extraHosts = ''
    23.62.88.204 origin.extole.io origin.pr.extole.io
  '';
  networking.hostName = vars.hostName;
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;

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

  services.tlp.enable = false;
  services.upower.enable = true;
  services.sshd.enable = true;

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

    synaptics.enable = true;
    synaptics.tapButtons = false;
    synaptics.twoFingerScroll = true;
    synaptics.palmDetect = true;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers."${vars.username}" = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "systemd-journal" "systemd-network" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  #system.stateVersion = "16.03";
}
