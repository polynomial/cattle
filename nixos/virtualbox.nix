{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/programs/virtualbox.nix> ];
  services.virtualboxHost.enable = true;
  users.extraGroups.vboxusers.members = [ "bsmith" ];
}
