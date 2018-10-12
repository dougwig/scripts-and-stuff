#!/bin/bash

kernels_installed=$(ls /boot/initrd.img-* | perl -ne '/-([0-9]+)-generic/ && print "$1\n";' | sort -n)
kernel_current=$(uname -a | perl -ne '/-([0-9]+)-generic / && print "$1\n";')
kernel_latest=$(echo "$kernels_installed" | tail -1)

kernels_excess=$(echo "$kernels_installed" | egrep -v "${kernel_current}|${kernel_latest}")

echo "latest kernel: $kernel_latest, running kernel: $kernel_current"

cd /boot
for v in $kernels_excess; do
	for file in `ls *-${v}-generic`; do
		if [ -s "$file" ]; then
			echo "removing $file"
			echo -n > "$file"
		fi
	done
done

apt-get -y autoremove
df -h

