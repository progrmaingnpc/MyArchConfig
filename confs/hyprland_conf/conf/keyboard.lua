hl.config({
    input = {
        kb_layout   = "us,ro,il",
        kb_variant  = ",std,",     -- one slot per layout, empty = default variant
        kb_model    = "",
        kb_options  = "grp:win_space_toggle",
        kb_rules    = "",
        numlock_by_default = true,
        mouse_refocus = false,
        follow_mouse = 1,
        sensitivity = 0,
        -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = false,
        },
    },
})
