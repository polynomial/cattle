{ config, pkgs, ... }:

{
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
    
}
