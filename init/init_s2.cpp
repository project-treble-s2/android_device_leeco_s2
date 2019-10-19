/*
   Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
   Copyright (c) 2017-2018, The LineageOS Project

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "property_service.h"
#include "vendor_init.h"

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#define DEVINFO_FILE "/dev/block/bootdevice/by-name/devinfo"

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_triple(char const product_prop[], char const system_prop[], char const vendor_prop[], char const value[])
{
    property_override(product_prop, value);
    property_override(system_prop, value);
    property_override(vendor_prop, value);
}

static int read_file2(const char *fname, char *data, int max_size)
{
    int fd, rc;
    if (max_size < 1)
        return 0;
    fd = open(fname, O_RDONLY);
    if (fd < 0) {
        return 0;
    }
    rc = read(fd, data, max_size - 1);
    if ((rc > 0) && (rc < max_size))
        data[rc] = '\0';
    else
        data[0] = '\0';
    close(fd);
    return 1;
}

void vendor_load_properties() {
    char device[PROP_VALUE_MAX];
    int isX520 = 0, isX522 = 0, isX526 = 0, isX527 = 0;

    // Default props
    if (read_file2(DEVINFO_FILE, device, sizeof(device)))
    {
        if (!strncmp(device, "s2_open", 7))
        {
            isX520 = 1;
        }
        else if (!strncmp(device, "s2_oversea", 10))
        {
            isX522 = 1;
        }
        else if (!strncmp(device, "s2_india", 8))
        {
            isX526 = 1;
        }
        else if (!strncmp(device, "s2_ww", 5))
        {
            isX527 = 1;
        }
    }

    if (isX520)
    {
        // This is X520
        property_override_triple("ro.product.model", "ro.product.system.model", "ro.product.vendor.model", "X520");
    }
    else if (isX522)
    {
        // This is X522
        property_override_triple("ro.product.model", "ro.product.system.model", "ro.product.vendor.model", "X522");
    }
    else if (isX526)
    {
        // This is X526
        property_override_triple("ro.product.model", "ro.product.system.model", "ro.product.vendor.model", "X526");
    }
    else if (isX527)
    {
        // This is X527
        property_override_triple("ro.product.model", "ro.product.system.model", "ro.product.vendor.model", "X527");
    }
    else
    {
        // Unknown variant
        property_override_triple("ro.product.model", "ro.product.system.model", "ro.product.vendor.model", "X52X");
    }
}
