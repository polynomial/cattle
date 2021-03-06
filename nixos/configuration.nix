# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./virtualbox.nix
      ./vpnc.nix
      ./users.nix
      ./xserver.nix
    ];

  security.sudo.wheelNeedsPassword = false; # maybe I am power hungry?

  networking.hostName = "bsmith-laptop"; # Define your hostname.
  networking.hostId = "f18ed587";
  networking.wireless.enable = true;

  i18n = {
    consoleKeyMap = "dvorak";
  };

  services.acpid.enable = true;
  #services.rsyslogd.enable = true;
  services.upower.enable = true;
  services.openssh.enable = true;

  programs.ssh.agentTimeout = "12h";
  programs.zsh.enable = true;

  powerManagement.enable = true;
  time.timeZone = "America/Los_Angeles";
  fonts.enableCoreFonts = true;

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];
  nix.trustedBinaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  
  environment.systemPackages = with pkgs; [
    xpdf
    firefox
    awscli
    #keybase-node-client
    gimp
    gnupg
    vpnc
    ack
    awesome
    python
    python3
    autoconf
    automake
    xflux
    cmake
    gnumake
    python27Packages.pip
    pypy
    mtr
    xclip
    terminus_font
    xlibs.xbacklight
    bc
    oraclejdk8
    rxvt
    acpi
    hugin
    autojump
    axel
    bind
    binutils
    chromium
    dmenu
    evince
    file
    gitFull
    htop
    keepassx
    mg
    mplayer
    nix-repl
    openconnect
    powertop
    rxvt_unicode
    sbt
    vim
    scrot
    silver-searcher
    terminator
    xdg_utils
    xlibs.xev
    xlibs.xset
  ];

  nixpkgs.config = {

    allowUnfree = true;

    config.firefox.enableGoogleTalkPlugin = true;
    config.firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

  };

}
