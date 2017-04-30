{ config, pkgs, ... }:

let

in
{
  security.sudo.wheelNeedsPassword = false; # maybe I am power hungry?

  networking.hostName = "huugs-sp3"; # Define your hostname.
  networking.hostId = "f18ed587";
  networking.wireless.enable = true;

  i18n = {
    consoleKeyMap = "dvorak";
  };

  services.acpid.enable = true;
  services.upower.enable = true;
  services.openssh.enable = true;

  programs.ssh.agentTimeout = "12h";
  programs.zsh.enable = true;

  powerManagement.enable = true;
  time.timeZone = "America/Los_Angeles";
  fonts.enableCoreFonts = true;

  #nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];
  #nix.trustedBinaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  nixpkgs.config = {

    allowUnfree = true;

    config.firefox.enableGoogleTalkPlugin = true;
    config.firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

  };

}
