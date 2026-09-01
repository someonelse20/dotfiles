-- autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("[workspace 1] waterfox")
	hl.exec_cmd("[workspace 2] kitty")
end)

-- binds
local mainMod = "SUPER"

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
