#!/bin/bash
#
#	by wangdd 2016/06/22
#


#快速创建虚拟机
xml_template="kvm_template.xml"
computer_name="centos01"
new_xml="centos-7.2.xml"
new_disk="centos-7.2.raw"
disk_size="30G"
iso_path="/work/soft/kvm/centos-7.2.iso"
image_path="/work/soft/kvm/centos-7.2.raw"
UUID=`uuidgen`
function configer_xml(){
	[[ ! -f "$new_xml" ]] && cp $xml_template $new_xml || echo "$new_xml exsit"
	[[ ! -f "$new_disk" ]] && qemu-img create -f raw $new_disk $disk_size || echo "$new_disk exsit"
	if [ $? -eq 0 ];then
		sed -i "s,%HOSTNAME%,$computer_name,g" $new_xml
		sed -i "s,%UUID%,$UUID,g" $new_xml
		sed -i "s,%IMAGE_PATH%,$image_path,g" $new_xml
		sed -i "s,%ISO_PATH%,$iso_path,g" $new_xml
		MAC="fa:95:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:4/')"
		sed -i "s,%MAC%,$MAC,g" $new_xml
		MAC2="52:54:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:4/')"
		sed -i "s,%MAC2%,$MAC2,g" $new_xml
		virsh define $new_xml >/dev/null 2>&
		virsh start $computer_name >/dev/null 2>&
		virsh vncdisplay $computer_name
	fi
}
