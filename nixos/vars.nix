{ pkgs ? import <nixpkgs> {} }:
{
  hostName = "bsmith-imac";
  timeZone = "America/Los_Angeles";
  systemPackages = with pkgs; [
    #grafana
    #opera
    gptfdisk
    lsof
    parted
    tcpdump
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
  ];

  layout = "dvorak"; # set for services.xserver.layout
  username = "bsmith";
}
