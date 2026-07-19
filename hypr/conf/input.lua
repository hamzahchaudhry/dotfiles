hl.config({
    input = {
        sensitivity = 0.5,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({
    name = "2.4g-wireless-mouse",
    sensitivity = -0.5
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
