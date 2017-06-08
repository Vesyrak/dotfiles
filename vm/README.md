# How to install a succesful GPU passthrough with single keyboard & mouse:
**IMPORTANT NOTICE:** It's been a while since I set this up, there might be a
step or 2 missing, since I recall having some trouble with it. Will update when
I reimage my desktop.

Included in this folder is my working .xml
## Sources: 
* https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_IOMMU
* https://www.kraxel.org/blog/2016/04/linux-evdev-input-support-in-qemu-2-6/

## Preparing OS for passthrough
This guide mainly follows the Arch Linux Wiki, use that for reference.

1. Make sure IOMMU is enabled
	```
	dmesg|grep -e DMAR -e IOMMU
	```

1. Run following script to find IOMMU groups
	```
	shopt -s nullglob
	for d in /sys/kernel/iommu_groups/*/devices/*; do 
	    n=${d#*/iommu_groups/*}; n=${n%%/*}
	    printf 'IOMMU Group %s ' "$n"
	    lspci -nns "${d##*/}"
	done;
	```

	Find the group containing your graphics card.
	The required code will be something of xxxx:xxxx in hex.
	Write down all the codes of the group number's members (all will be
	forwarded, make sure this doesn't cause problems)(Do not forward a PCIe
	controller if there is one.)

1. Make sure you have vfio-pci (Alternative exist, but won't be used here)
	```
	modinfo vfio-pci
	```

1. Add following to file */etc/modprobe.d/vfio.conf*
	```
	options vfio-pci ids=<code1>,<code2>,<code...>
	```

1. Add following to the required sections in */etc/mkinitcpio.conf*
	```
	MODULES="... vfio vfio_iommu_type1 vfio_pci vfio_virqfd ..."
	HOOKS="... modconf ..."
	```

1. Regenerate initramfs
	```
	mkinitcpio -p linux
	```

1. Reboot and run the following to check they are bound properly
	```
	dmesg | grep -i vfio
	```

1. Add the following to the *nvram* section of */etc/libvirt/qemu.conf*
	```
	nvram = [
		"/usr/share/ovmf/ovmf_code_x64.bin:/usr/share/ovmf/ovmf_vars_x64.bin"
	]
	```

1. enable & start/restart libvirtd service (script enables it for you, just
   restart)
1. Create/Import virtual machine with virt-manager
    1. If creating, make sure you customize before install
    1. Set the BIOS to UEFI (if grayed out, make sure qemu.conf is correct and
       restart the libvirtd service)
    1. Change CPU model to *host-passthrough*
1. Add isolated PCI device via virt-manager


## For allowing input switching:
Make sure the evdev's are correct, if changed/removed you need to re-edit,
otherwise VM won't boot.
This allows you to change OS by pressing both CTRL buttons.

**Do the editing via "sudo virsh edit < vmname >"**

Enter before < /domain >:
```
<qemu:commandline>
  <qemu:arg value='-object'/>
  <qemu:arg value='input-linux,id=kbd,evdev=/dev/input/by-id/usb-04d9_USB_Keyboard-event-kbd,grab_all=on'/>
  <qemu:arg value='-object'/>
  <qemu:arg value='input-linux,id=mouse,evdev=/dev/input/by-id/usb-Logitech_USB_Optical_Mouse-event-mouse'/>
</qemu:commandline>
```

