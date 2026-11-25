function vm
    doas rc-service --ifnotstarted libvirtd start; or return
    set -l uri qemu:///system

    # OpenRC can return before libvirtd accepts connections.
    for attempt in (seq 20)
        virsh -c "$uri" uri >/dev/null 2>&1; and break
        sleep 0.25
    end

    set -l state (LC_ALL=C virsh -c "$uri" domstate win11); or return

    if test "$state" = 'shut off'
        virsh -c "$uri" start win11; or return
    end

    virt-manager --connect "$uri" --show-domain-console win11 &
    disown
end
