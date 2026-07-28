hl.curve("default", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
