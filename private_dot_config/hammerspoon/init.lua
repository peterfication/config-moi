hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Config loaded")

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

local current_id, threshold
local swipe = hs.loadSpoon("Swipe")
swipe:start(4, function(direction, distance, id)
	if id == current_id then
		if distance > threshold then
			-- only trigger once per swipe
			threshold = math.huge

			-- NOTE: left swipe is right movement in Aerospace, and right swipe is left movement in Aerospace
			if direction == "left" then
				-- Trigger Aerospace right (hyper+k)
				hs.eventtap.keyStroke({ "ctrl", "alt", "cmd", "shift" }, "k")
			elseif direction == "right" then
				-- Trigger Aerospace left (hyper+j)
				hs.eventtap.keyStroke({ "ctrl", "alt", "cmd", "shift" }, "j")
				-- elseif direction == "up" then
				-- 	-- ...
				-- elseif direction == "down" then
				-- 	-- ...
			end
		end
	else
		current_id = id
		-- swipe distance > 20% of trackpad
		threshold = 0.1
	end
end)

local tailscaleBin = "/usr/local/bin/tailscale"

local function toggleCaffeine()
	if hs.caffeinate.get("displayIdle") then
		hs.alert.show("Caffeine off")
	else
		hs.alert.show("Caffeine on")
	end

	spoon.Caffeine:clicked()
end

local function runTailscale(args, onExit)
	local task = hs.task.new(tailscaleBin, function(exitCode, stdOut, stdErr)
		if onExit then
			onExit(exitCode, stdOut, stdErr)
		end
	end, args)

	if not task then
		hs.alert.show("Failed to start Tailscale CLI")
		return
	end

	task:start()
end

local function toggleTailscale()
	runTailscale({ "status", "--json" }, function(exitCode, stdOut, stdErr)
		if exitCode ~= 0 then
			hs.alert.show("Tailscale status failed")
			if stdErr and stdErr ~= "" then
				print(stdErr)
			end
			return
		end

		local status = hs.json.decode(stdOut)
		if not status or not status.BackendState then
			hs.alert.show("Tailscale status unreadable")
			return
		end

		local nextArgs = { "up" }
		local nextLabel = "Tailscale connected"

		if status.BackendState == "Running" then
			nextArgs = { "down" }
			nextLabel = "Tailscale disconnected"
		end

		runTailscale(nextArgs, function(toggleExitCode, _, toggleErr)
			if toggleExitCode == 0 then
				hs.alert.show(nextLabel)
				return
			end

			hs.alert.show("Tailscale toggle failed")
			if toggleErr and toggleErr ~= "" then
				print(toggleErr)
			end
		end)
	end)
end

require("hyper_space").setup({
	toggleCaffeine = toggleCaffeine,
	toggleTailscale = toggleTailscale,
})
