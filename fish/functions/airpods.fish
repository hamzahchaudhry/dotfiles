function airpods
    set -l mac 38:C4:3A:E2:E2:D8

    if test "$argv[1]" = off
        doas rc-service --ifstarted bluetooth stop; or return
        doas rfkill block bluetooth
    else
        doas rfkill unblock bluetooth; or return
        doas rc-service --ifnotstarted bluetooth start; or return
        sleep 0.3
        bluetoothctl connect $mac
    end
end
