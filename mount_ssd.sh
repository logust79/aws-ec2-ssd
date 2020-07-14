#!/bin/bash -x
mounted=$(mount | grep 'ssddata' -c)
if [ $mounted -ne 1 ]; then
	echo 'here'
	for DEV in /dev/disk/by-id/nvme-Amazon_EC2_NVMe_Instance_Storage_*-ns-1; do
		pvcreate ${DEV}
	done

	vgcreate datavg /dev/disk/by-id/nvme-Amazon_EC2_NVMe_Instance_Storage_*-ns-1
	lvcreate -l 100%FREE -n ssddata datavg
	mkfs.ext4 /dev/datavg/ssddata
	mkdir -p /mnt/ssddata
	mount /dev/datavg/ssddata /mnt/ssddata 
	mkdir -p /mnt/ssddata/data
	chmod 777 /mnt/ssddata/data
fi

