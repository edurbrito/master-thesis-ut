#! /bin/sh


# VDESWITCH=vde_switch

# killall -q wirefilter
# killall -q vde_switch

# for i in $(seq 1 "${NUM_SESSIONS}"); do
#     ${VDESWITCH} -d --hub --sock num${i}.ctl
# done

# wirefilter --daemon -v num1.ctl:num2.ctl
# wirefilter --daemon -v num2.ctl:num3.ctl
# wirefilter --daemon -v num3.ctl:num1.ctl
