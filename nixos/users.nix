{ config, pkgs, ... }:

{
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
}
