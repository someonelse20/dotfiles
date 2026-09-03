-- autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("[workspace 11] waterfox")
	hl.exec_cmd("[workspace 1] kitty")
end)
