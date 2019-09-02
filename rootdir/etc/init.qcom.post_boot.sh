#! /vendor/bin/sh
# Copyright (c) 2012-2013, 2016-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Set Memory parameters.
#
# Set per_process_reclaim tuning parameters
# All targets will use vmpressure range 50-70,
# All targets will use 512 pages swap size.
#
# Set allocstall_threshold to 0 for all targets.

echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
echo 70 > /sys/module/process_reclaim/parameters/pressure_max
echo 50 > /sys/module/process_reclaim/parameters/pressure_min
echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
echo 0 > /sys/module/vmpressure/parameters/allocstall_threshold
echo 60 > /proc/sys/vm/swappiness

panel=`cat /sys/class/graphics/fb0/modes`
if [ "${panel:5:1}" == "x" ]; then
    panel=${panel:2:3}
else
    panel=${panel:2:4}
fi

# Apply Scheduler and Governor settings for 8976
# SoC IDs are 266, 274, 277, 278
# HMP scheduler (big.Little cluster related) settings
echo 95 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_downmigrate
echo 2 > /proc/sys/kernel/sched_window_stats_policy
echo 5 > /proc/sys/kernel/sched_ravg_hist_size
echo 3 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_nr_run

for devfreq_gov in /sys/class/devfreq/*qcom,mincpubw*/governor
do
    echo "cpufreq" > $devfreq_gov
done

for devfreq_gov in /sys/class/devfreq/*qcom,cpubw*/governor
do
    echo "bw_hwmon" > $devfreq_gov
    for cpu_io_percent in /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/io_percent
    do
        echo 20 > $cpu_io_percent
    done
    for cpu_guard_band in /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/guard_band_mbps
    do
    echo 30 > $cpu_guard_band
    done
done

for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
do
    echo 40 > $gpu_bimc_io_percent
done

# enable governor for power cluster
echo 1 > /sys/devices/system/cpu/cpu0/online
echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 80 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
echo 400000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 59000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
echo 806400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
echo "1 400000:60 691200:80" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads

# enable governor for perf cluster
echo 1 > /sys/devices/system/cpu/cpu4/online
echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 85 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
echo 400000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 60000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
echo 1113600 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
echo "19000 1113600:39000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
echo "85 1113600:90 1612800:80" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads

# HMP Task packing settings for 8976
echo 30 > /proc/sys/kernel/sched_small_task
echo 20 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_load

# Disable sched boost
echo 0 > /proc/sys/kernel/sched_boost

# Bring up all cores online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online
echo 1 > /sys/devices/system/cpu/cpu6/online
echo 1 > /sys/devices/system/cpu/cpu7/online

# Enable LPM Prediction
echo 1 > /sys/module/lpm_levels/parameters/lpm_prediction

# remove interaction lock when idle
echo 100 > /sys/devices/virtual/graphics/fb0/idle_time

# Disable L2 GDHS on 8976
echo N > /sys/module/lpm_levels/system/a53/a53-l2-gdhs/idle_enabled
echo N > /sys/module/lpm_levels/system/a72/a72-l2-gdhs/idle_enabled

# Enable sched guided freq control
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
echo 50000 > /proc/sys/kernel/sched_freq_inc_notify
echo 50000 > /proc/sys/kernel/sched_freq_dec_notify

# Enable timer migration to little cluster
echo 1 > /proc/sys/kernel/power_aware_timer_migration

# Start energy-awareness for 8976
start vendor.energy-awareness

#enable sched colocation and colocation inheritance
echo 130 > /proc/sys/kernel/sched_grp_upmigrate
echo 110 > /proc/sys/kernel/sched_grp_downmigrate
echo   1 > /proc/sys/kernel/sched_enable_thread_grouping

# Parse misc partition path and set property
misc_link=$(ls -l /dev/block/bootdevice/by-name/misc)
real_path=${misc_link##*>}
setprop persist.vendor.mmi.misc_dev_path $real_path

# Set BFQ as default io-schedular after boot
setprop sys.io.scheduler "bfq"
