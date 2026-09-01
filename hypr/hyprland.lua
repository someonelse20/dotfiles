require("modules.env")
require("modules.monitors")
require("modules.core")
require("modules.autostart")
require("modules.rules")
require("modules.binds")

print(hl.get_config("cursor.default_monitor"))

if os.getenv("HOSTNAME") == "archlaptop" then
	require("machines.laptop")
else
	require("modules.split-monitor")
	require("machines.desktop")
end

--[[
local machine = os.getenv("XDG_SESSION_OPT") or "cel"
pcall(require, "machines." .. machine)
--]]
