local home = os.getenv("HOME")

local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

require("git"):setup()
require("duckdb"):setup()

local bookmarks = {
	{ key = "/", path = "/", desc = "Root" },
	{ key = "h", path = "h", desc = "Home" },
	{ key = "s", path = "~/Pictures/Screenshots", desc = "~/Pictures/Screenshots" },
	{ key = "d", path = "~/Downloads", desc = "~/Downloads" },
	{ key = "D", path = "~/Documents", desc = "~/Documents" },
	{ key = "c", path = "~/.config", desc = "~/.config" },
	{ key = "C", path = "~/config", desc = "~/config" },
	{ key = "l", path = "~/.local", desc = "~/.local " },
}
local extra_bookmarks_path = home .. "/.config/yazi/local_bookmarks.lua"
local extra_bookmarks = nil
if file_exists(extra_bookmarks_path) then
	extra_bookmarks = dofile(extra_bookmarks_path)
end
if extra_bookmarks then
	for _, bm in ipairs(extra_bookmarks) do
		table.insert(bookmarks, bm)
	end
end
require("bunny"):setup({
	hops = bookmarks,
})
