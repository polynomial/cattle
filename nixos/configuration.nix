# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./extole-vpn.nix
      ./hardware-configuration.nix
      ./nixos-hardware/lenovo/thinkpad/x1/default.nix
    ];


  services.dnsmasq.enable = true;
  services.dnsmasq.extraConfig = ''
    server=/vpn.intole.net/8.8.8.8
    server=/.ec2.internal/10.1.0.2
    server=/.intole.net/10.1.0.2
    conf-dir=/etc/dnsmasq.d
  '';

  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.hostName = "huuuuuuuuugs";
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "America/Los_Angeles";
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.

  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.extraUsers."bsmith" = {
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" "audio" "video" "systemd-journal" "systemd-network" "adbusers"];
  };
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
  powerManagement.enable = true;
  services.upower.enable = true;
  nixpkgs.config = {
    android_sdk.accept_license = true;

    allowUnfree = true;
    pulseaudio = true;
  };
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  services.thinkfan.enable = true;
  programs.adb.enable = true;
  services.xserver = {
    enable = true;
    layout = "dvorak";
    videoDrivers = [ "intel" "nvidia" ];
    #videoDrivers = [ "nvidia" "intel" ];
    #videoDrivers = [ "nvidia" ];
    windowManager.default = "awesome";
    windowManager.awesome.enable = true;
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "bsmith";
    displayManager.slim.theme = pkgs.fetchFromGitHub {
        owner = "polynomial";
        repo = "nixos-slim-theme";
        rev = "bea4127728b161aa4bc4993e5a7f796a75001d04";
        sha256 = "sha256:1r0sykpq7974ccgd5yb61x335whq7bfrh5k0mg0vmsj8kn7wfj0p";
      };

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
  };

  hardware.opengl.enable = true;
  programs.zsh.enable = true;
  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;


 
   

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
