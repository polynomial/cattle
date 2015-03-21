# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  hsPackages = with pkgs.haskellPackages; [
    cabal2nix
    cabalInstall
    djinn
    doctest
    ghc
    ghcCore
    ghcid
    hlint
    idris
    pandoc
    pointfree
    pointful
    purescript
    stylishHaskell
    taffybar
    xmobar
    yeganesh
  ];
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vpnc.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "bsmith-laptop"; # Define your hostname.
  networking.hostId = "f18ed587";
  networking.wireless.enable = true;  # Enables wireless.
#  networking.vpnc.enable = true;


  # Select internationalisation properties.
  i18n = {
    # consoleFont = "lat9w-16";
    consoleKeyMap = "dvorak";
    # defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget
  # ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  services.acpid.enable = true;
  services.rsyslogd.enable = true;
  powerManagement.enable = true;
  time.timeZone = "America/Los_Angeles";
  fonts.enableCoreFonts = true;

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];
  nix.trustedBinaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  programs.light.enable = true;

  environment.systemPackages = with pkgs; [
    keybase-node-client
    gnupg
    vpnc
    ack
    awesome
    python
#    python2.7-pip
    autoconf
    cmake
    gnumake
    xscreensaver
    rxvt
    acpi
    autojump
    axel
    bind
    binutils
    chromium
    dmenu
    emacs
    evince
    file
    gitFull
    htop
    (haskellPackages.hoogleLocal.override {
      packages = hsPackages;
    })
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
    vagrant
    wpa_supplicant_gui
    xdg_utils
    xlibs.xev
    xlibs.xset
  ] ++ hsPackages;
  services.xserver = {
    enable = true;

    vaapiDrivers = [ pkgs.vaapiIntel ];

    layout = "us";

    xkbVariant = "dvorak";
    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager = {
      desktopManagerHandlesLidAndPower = false;
    };
    windowManager.default = "awesome";
    windowManager.awesome.enable = true;
    windowManager.xmonad.enable = false;
    
    # TODO: Use the mtrack driver but do better than this.
    # multitouch.enable = true;
    # multitouch.invertScroll = true;

    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-100"
      Option "HorizScrollDelta" "-100"
    '';
    synaptics.buttonsMap = [ 1 2 3 ];
    synaptics.enable = true;
    synaptics.tapButtons = false;
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;
  
    videoDrivers = [ "intel" ];

    screenSection = ''
      Option "DPI" "96 x 96"
      Option "NoLogo" "TRUE"
      Option "nvidiaXineramaInfoOrder" "DFP-2"
      Option "metamodes" "HDMI-0: nvidia-auto-select +0+0, DP-2: nvidia-auto-select +1920+0 {viewportin=1680x1050}"
    '';
  
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
    
  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;
    
    packageOverrides = pkgs: {
      linux_3_17 = pkgs.linux_3_17.override {
        extraConfig =
        ''
          THUNDERBOLT m
        '';
      };
    };
  };
    
  users.extraUsers.bsmith = {
    name = "bsmith";
    group = "users";
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/bsmith";
    shell = "/run/current-system/sw/bin/zsh";
  };

  services.upower.enable = true;
  services.openssh.enable = true;
  programs.ssh.agentTimeout = "12h";
  programs.zsh.enable = true;

}
