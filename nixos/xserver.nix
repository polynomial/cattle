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
  
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
    
}
