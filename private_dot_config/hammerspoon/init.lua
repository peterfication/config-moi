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
local tailscaleExitNodesByHost = {
	["Peters-MacBook-Pro"] = "vpn",
	default = "vpn",
}

local function trim(value)
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function tailscaleExitNodeForHost()
	local localHostName = trim(hs.execute("/usr/sbin/scutil --get LocalHostName") or "")
	return tailscaleExitNodesByHost[localHostName] or tailscaleExitNodesByHost.default
end

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

local function toggleTailscaleExitNode()
	runTailscale({ "debug", "prefs" }, function(exitCode, stdOut, stdErr)
		if exitCode ~= 0 then
			hs.alert.show("Tailscale prefs failed")
			if stdErr and stdErr ~= "" then
				print(stdErr)
			end
			return
		end

		local prefs = hs.json.decode(stdOut)
		if not prefs then
			hs.alert.show("Tailscale prefs unreadable")
			return
		end

		local exitNode = tailscaleExitNodeForHost()
		if not exitNode or exitNode == "" then
			hs.alert.show("No Tailscale exit node configured")
			return
		end

		local nextArgs = { "set", "--exit-node=" .. exitNode }
		local nextLabel = "Tailscale exit node: " .. exitNode

		if (prefs.ExitNodeID and prefs.ExitNodeID ~= "") or (prefs.ExitNodeIP and prefs.ExitNodeIP ~= "") then
			nextArgs = { "set", "--exit-node=" }
			nextLabel = "Tailscale exit node: off"
		end

		runTailscale(nextArgs, function(toggleExitCode, _, toggleErr)
			if toggleExitCode == 0 then
				hs.alert.show(nextLabel)
				return
			end

			hs.alert.show("Tailscale exit node toggle failed")
			if toggleErr and toggleErr ~= "" then
				print(toggleErr)
			end
		end)
	end)
end

local function disableFluxForHour()
	local ok, result = hs.osascript.applescript([[
		tell application id "org.herf.Flux" to activate
		delay 0.2

		tell application "System Events"
			tell process "Flux"
				repeat with menuBarIndex from 1 to count menu bars
					repeat with menuBarItemIndex from 1 to count menu bar items of menu bar menuBarIndex
						try
							click menu bar item menuBarItemIndex of menu bar menuBarIndex
							delay 0.01

							set targetMenu to menu 1 of menu bar item menuBarItemIndex of menu bar menuBarIndex
							if exists menu item "Disable for an hour" of targetMenu then
								click menu item "Disable for an hour" of targetMenu
								key code 36
								return "Flux disabled for an hour"
							end if

							if exists menu item "Disable for an hour (with dimming)" of targetMenu then
								click menu item "Disable for an hour (with dimming)" of targetMenu
								key code 36
								return "Flux disabled for an hour"
							end if

							if exists menu item "Disable" of targetMenu then
								set disableItem to menu item "Disable" of targetMenu
								perform action "AXPress" of disableItem
								delay 0.01
								key code 36
								return "Flux disabled for an hour"
							end if

							key code 53
						end try
					end repeat
				end repeat
			end tell
		end tell

		return "Flux menu item not found"
	]])

	if ok then
		hs.alert.show(result)
	else
		hs.alert.show("Flux disable failed")
		print(result)
	end
end

require("hyper_space").setup({
	toggleCaffeine = toggleCaffeine,
	disableFluxForHour = disableFluxForHour,
	toggleTailscale = toggleTailscale,
	toggleTailscaleExitNode = toggleTailscaleExitNode,
})
