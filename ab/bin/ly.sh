#!/bin/bash
. /etc/init.d/functions
CONF_DIR=/etc/libvirt/qemu
IMG_DIR=/var/lib/libvirt/images

function createvm(){
    if  [ -e ${IMG_DIR}/${1}.img ];then
        echo_warning
        echo "vm ${1}.img is exists"
        return 1
    else
        qemu-img create -b ${IMG_DIR}/.node_tedu.qcow2 -f qcow2 ${IMG_DIR}/${1}.img 30G &>/dev/null
        sed -e "s,node_tedu,${1}," ${IMG_DIR}/.node_tedu.xml >${CONF_DIR}/${1}.xml
        sudo virsh define ${CONF_DIR}/${1}.xml &>/dev/null
        echo_success
        echo "vm ${1} create"
    fi
}

# main
id=0
if  (( $# != 1 ));then
    echo "$0 number"
else
    declare -i Number=$1
    if  (( Number < 1 )) || (( Number > 99 ));then
        echo 'number must is { 1 to 99 }'
        exit 1
    else
        while ((Number));do
           ((id++))
           vm_name=$(printf "tedu_node%02d" ${id})
           if  [ -e ${IMG_DIR}/${vm_name}.img ];then
               continue
           else
               createvm ${vm_name}
           fi
           ((Number--))
        done 
    fi
fi
