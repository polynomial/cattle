# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d13eb3cb-75fe-4a39-adcf-3be8abe95068";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."nixosroot".device = "/dev/disk/by-uuid/62bfee6c-f845-4f8d-9612-a68c9f5b5047";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/563D-0E0F";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/48bc4d10-279b-4417-bd14-b3ea9588aaae"; }
    ];

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
