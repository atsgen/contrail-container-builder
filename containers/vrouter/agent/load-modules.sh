#!/bin/bash
# Copyright (c) 2020 ATSgen, all rights reserved.
#

function load_vrouter_module() {
    local TF_MODULES_DIR="/tungsten/modules"
    if [ ! -d "$TF_MODULES_DIR" ]; then
        return
    fi
    local kver=$(uname -r)
    if [ -d "/lib/modules/$kver/kernel/net/vrouter" ]; then
        return
    fi
    mkdir -p /lib/modules/$kver/kernel/net/vrouter
    local mod_dir=$(find $TF_MODULES_DIR/. -type f -name "vrouter.ko" | awk  -F "/" '{print($(NF-1))}')
    local available_modules=$(echo "$mod_dir" | sed 's/\.el/ el/' | sort -V | sed 's/ /./1')
    if echo "$available_modules" | grep -q "$kver"; then
        cp $TF_MODULES_DIR/$kver/* /lib/modules/$kver/kernel/net/vrouter/
        return
    fi
    local sorted_list=$(echo -e "${available_modules}\n${kver}" | sed 's/\.el/ el/' | sort -V | sed 's/ /./1')
    if ! echo "$sorted_list" | grep -B1 "$kver" | grep -vq "$kver" ; then
        cp $TF_MODULES_DIR/$(echo "$available_modules" | head -1)/* /lib/modules/$kver/kernel/net/vrouter/
        return
    else
        cp $TF_MODULES_DIR/$(echo "$sorted_list" | grep -B1 "$kver" | grep -v "$kver")/* /lib/modules/$kver/kernel/net/vrouter/
        return
    fi
}

function load_host_modules() {
    local kver=$(uname -r)
    if [ -d "/host/modules" ]; then
        if [ -d "/lib/modules/$kver" ]; then
            return
        fi
        cp -rp /host/modules/$kver /lib/modules/$kver
    fi
}

function tungsten_init() {
    load_host_modules
    load_vrouter_module
    depmod -a
}
