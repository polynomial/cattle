{ pkgs ? import <nixpkgs> {} }:
{
  hostName = "bsmith-y900";
  timeZone = "America/Los_Angeles";
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
    acpi
    binutils
    #chromium
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
    pcsctools
  ];

  layout = "dvorak"; # set for services.xserver.layout
  username = "bsmith";
}
