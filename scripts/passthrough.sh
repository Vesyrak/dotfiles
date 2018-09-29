#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function prepare() {
  sudo apt install qemu-system-x86 qemu-utils ovmf libvirt-daemon virt-manager
  sudo perl -i -pe 's/(GRUB_CMDLINE_LINUX_DEFAULT=.*)"/\1 intel_iommu=on"/' /etc/default/grub
  sudo update-grub
  sudo dmesg | grep -e DMAR -e IOMMU
}

function checkIOMMUGroups() {
  for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d);
    do echo "IOMMU group $(basename "$iommu_group")";
    for device in $(ls -1 "$iommu_group"/devices/);
      do echo -n $'\t'; lspci -nns "$device";
    done;
  done
}

function echoVFIODevices() {
  read -p ":: Please enter the VGA ID: " VGAPT_VGA_ID
  read -p ":: Please enter the VGA Audio ID: " VGAPT_VGA_AUDIO_ID
  echo options vfio-pci ids=$VGAPT_VGA_ID,$VGAPT_VGA_AUDIO_ID | sudo tee -a /etc/modprobe.d/vfio.conf > /dev/null
  echo vfio | sudo tee -a /etc/modules-load.d/vfio.conf > /dev/null
  echo vfio_pci | sudo tee -a /etc/modules-load.d/vfio.conf > /dev/null
  sudo update-initramfs -u
}

function blacklistNouveau() {
  echo blacklist nouveau | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf > /dev/null
  echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf > /dev/null
  sudo update-initramfs -u
  sudo reboot
}

while getopts "pce" opt; do
  case $opt in
    p)
      prepare()
      ;;
    c)
      checkIOMMUGroups()
      ;;
    e)
      echoVFIODevices()
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
