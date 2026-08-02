hl.config({
	plugin = {
		split_monitor_workspaces = {
			count = 10,
			keep_focused = 0,
			enable_notifications = 1,
			enable_persistent_workspaces = 0,
			enable_wrapping = 1,
			link_monitors = 0,
			-- enable_hy3                = 1,
		},
	},
})

local smw = hl.plugin.split_monitor_workspaces
smw.monitor_priority({ "DP-1", "HDMI-A-1" })

smw.max_workspaces({ monitor = "DP-1", max = 10 })
smw.max_workspaces({ monitor = "HDMI-A-1", max = 10 })

local mainMod = "SUPER"

hl.bind(mainMod .. " + ALT + J", function()
	return smw.change_monitor_silent("-1")
end)
hl.bind(mainMod .. " + ALT + K", function()
	return smw.change_monitor_silent("+1")
end)

hl.bind(mainMod .. " + ALT + L", function()
	return smw.cycle_workspaces("+1")
end)

hl.bind(mainMod .. " + ALT + H", function()
	return smw.cycle_workspaces("-1")
end)

for i = 1, 10 do
	-- local key = tostring(i)
	local key = i % 10

	hl.bind(mainMod .. " + " .. key, function()
		return smw.workspace(i)
	end)
	hl.bind(mainMod .. " + SHIFT + " .. key, function()
		return smw.move_to_workspace(i)
	end)

	hl.bind(mainMod .. "+ ALT + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. "+ ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))

	hl.bind(mainMod .. "+ CTRL + " .. key, hl.dsp.focus({ workspace = i + 10 }))
	hl.bind(mainMod .. "+ CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i + 10 }))
end
--[[
--]]
