hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Config loaded")

-- Vim movements
hs.loadSpoon("FnMate")

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

local function toggleCaffeine()
	if hs.caffeinate.get("displayIdle") then
		hs.alert.show("Caffeine off")
	else
		hs.alert.show("Caffeine on")
	end

	spoon.Caffeine:clicked()
end

hs.hotkey.bind({ "alt", "ctrl", "cmd", "shift" }, "ö", toggleCaffeine)

require("hyper_space").setup({
	toggleCaffeine = toggleCaffeine,
})
