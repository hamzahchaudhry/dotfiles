function ethernet
    if test "$argv[1]" = off
        doas dhcpcd --exit enp0s13f0u1
        doas ip link set enp0s13f0u1 down
        doas rfkill unblock wifi
    else
        doas ip link set enp0s13f0u1 up
        doas dhcpcd enp0s13f0u1
        doas rfkill block wifi
    end
end
