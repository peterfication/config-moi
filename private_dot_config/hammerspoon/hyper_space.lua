local M = {}

function M.setup(opts)
	opts = opts or {}
	local home = os.getenv("HOME")
	local downloadsPath = home .. "/Downloads"
	local documentsPath = home .. "/Documents"
	local googleDrivePath = home .. "/Google Drive"
	local screenshotsPath = home .. "/Pictures/Screenshots"
  local iCloudDrivePath = home .. "/Library/Mobile Documents/com~apple~CloudDocs/tmp/"

	local function openPath(path)
		hs.task.new("/usr/bin/open", nil, { path }):start()
	end

	local function openGhostty(path)
		hs.task.new("/usr/bin/osascript", nil, {
			"-e",
			'tell application "Ghostty"',
			"-e",
			"activate",
			"-e",
			"set cfg to new surface configuration",
			"-e",
			('set initial working directory of cfg to "%s"'):format(path),
			"-e",
      "set win to new window with configuration cfg",
			"-e",
			"end tell",
		}):start()
	end

	-- Hyper+Space mode
	local hyperSpace = hs.hotkey.modal.new({ "ctrl", "alt", "cmd", "shift" }, "space")
	-- Hyper+Space+F mode for Finder
	local hyperSpaceF = hs.hotkey.modal.new()
	-- Hyper+Space+T mode for Terminal
	local hyperSpaceT = hs.hotkey.modal.new()
	-- Hyper+Space+M mode for Menu
	local hyperSpaceM = hs.hotkey.modal.new()

	-- Add key binding for Hyper+Space+F mode (Finder)
	local function bindHyperSpaceF(mods, key, path)
		hyperSpaceF:bind(mods, key, function()
			openPath(path)
			hyperSpaceF:exit()
			hyperSpace:exit()
		end)
	end

	-- Add key binding for Hyper+Space+T mode (Terminal)
	local function bindHyperSpaceT(mods, key, path)
		hyperSpaceT:bind(mods, key, function()
			openGhostty(path)
			hyperSpaceT:exit()
			hyperSpace:exit()
		end)
	end

	local function bindHyperSpaceM(mods, key, action)
		hyperSpaceM:bind(mods, key, function()
			action()
			hyperSpaceM:exit()
			hyperSpace:exit()
		end)
	end

	local hyperSpaceTimeout = nil

	function hyperSpace:entered()
		hs.alert.show("Hyper+Space mode")
		hyperSpaceTimeout = hs.timer.doAfter(2, function()
			hs.alert.show("Hyper+Space mode timeout")
			hyperSpace:exit()
			hyperSpaceTimeout = nil
		end)
	end

	function hyperSpace:exited()
		if hyperSpaceTimeout then
			hyperSpaceTimeout:stop()
			hyperSpaceTimeout = nil
		end
		hs.timer.doAfter(0.5, function()
			hs.alert.closeAll()
		end)
	end

	hyperSpace:bind({}, "f", function()
		hyperSpaceF:enter()
		hs.alert.show("Hyper+Space+F mode (Finder)")
	end)

	hyperSpace:bind({}, "t", function()
		hyperSpaceT:enter()
		hs.alert.show("Hyper+Space+T mode (Terminal)")
	end)

	hyperSpace:bind({}, "m", function()
		hyperSpaceM:enter()
		hs.alert.show("Hyper+Space+M mode (Menu)")
	end)

	hyperSpace:bind({}, "escape", function()
		hyperSpace:exit()
	end)
	hyperSpaceF:bind({}, "escape", function()
		hyperSpaceF:exit()
		hyperSpace:exit()
	end)
	hyperSpaceT:bind({}, "escape", function()
		hyperSpaceT:exit()
		hyperSpace:exit()
	end)
	hyperSpaceM:bind({}, "escape", function()
		hyperSpaceM:exit()
		hyperSpace:exit()
	end)

	bindHyperSpaceF({}, "d", downloadsPath)
	bindHyperSpaceF({ "shift" }, "d", documentsPath)
	bindHyperSpaceF({}, "g", googleDrivePath)
  bindHyperSpaceF({}, "i", iCloudDrivePath)
	bindHyperSpaceF({}, "s", screenshotsPath)

	bindHyperSpaceT({}, "d", downloadsPath)
	bindHyperSpaceT({ "shift" }, "d", documentsPath)
	bindHyperSpaceT({}, "g", googleDrivePath)
  bindHyperSpaceT({}, "i", iCloudDrivePath)
	bindHyperSpaceT({}, "s", screenshotsPath)

	if opts.toggleCaffeine then
		bindHyperSpaceM({}, "c", opts.toggleCaffeine)
	end
	if opts.toggleTailscale then
		bindHyperSpaceM({}, "t", opts.toggleTailscale)
	end
end

return M
