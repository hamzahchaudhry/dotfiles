function airpods
    set -l mac 38:C4:3A:E2:E2:D8

    if test "$argv[1]" = off
        bluetoothctl disconnect $mac
        doas rc-service bluetooth stop
        doas rfkill block bluetooth
    else
        doas rfkill unblock bluetooth
        doas rc-service bluetooth start
        sleep 0.5
        bluetoothctl connect $mac
    end
end
