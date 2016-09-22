{ pkgs ? import <nixpkgs> {} }:
{
  hostName = "huugs900";
  timeZone = "PST8PDT"; # or "America/Chicago" or something.
  systemPackages = with pkgs; [
    vim
    cryptsetup
    acpi
    xpdf
    gimp
    gnupg
    ack
    awesome
    xflux
    mtr
    xclip
    terminus_font
    xlibs.xbacklight
    bc
    zsh
    acpi
    binutils
    chromium
    evince
    file
    gitFull
    keepassx
    mg
    mplayer
    nix-repl
    powertop
    rxvt_unicode
    vim
    silver-searcher
    xlibs.xev
    xlibs.xset
    nfs-utils
    upower
  ];
  programs.zsh.enable = true;
  nixpkgs.config = {

    allowUnfree = true;

    config.firefox.enableGoogleTalkPlugin = true;
    config.firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

  };

  layout = "dvorak"; # set for services.xserver.layout
  username = "bsmith";
}
