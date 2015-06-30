# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usbhid" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.extraModprobeConfig = ''
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd-hda-intel mobel=mbp101
    options hid_apple fnmode=2
  '';
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e083c11a-3cf2-415e-a5d4-22bd50823a87";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A1EF-0E41";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/19669c90-1d8a-46c9-ae14-10d6e6d6b3d2";
      fsType = "xfs";
    };

  swapDevices = [ ];

  nix.maxJobs = 8;
}