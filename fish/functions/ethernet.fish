function ethernet
    set -l interface enp0s13f0u1

    if test "$argv[1]" = off
        doas rfkill unblock wifi; or return
        doas dhcpcd --exit $interface; or return
        doas ip link set $interface down
    else
        doas ip link set $interface up; or return
        doas dhcpcd $interface; or return
        doas rfkill block wifi
    end
end
