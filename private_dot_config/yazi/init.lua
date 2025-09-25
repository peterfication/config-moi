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

require("yatline"):setup({
	show_background = false,

	header_line = {
		-- Empty, so that starship is not overwritten
		-- left = {
		-- 	section_a = {
		-- 		{ type = "coloreds", custom = false, name = "githead" },
		-- 	},
		-- 	section_b = {},
		-- 	section_c = {},
		-- },
		-- right = {
		-- 	section_a = {
		-- 		{ type = "line", custom = false, name = "tabs", params = { "right" } },
		-- 	},
		-- 	section_b = {},
		-- 	section_c = {},
		-- },
	},

	status_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_path" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
require("starship"):setup({
	config_file = "~/.config/yazi/starship.toml",
})

require("mux"):setup({
	notify_on_switch = true,
	remember_per_file_suffix = true,
	aliases = {
		eza_tree_1 = {
			previewer = "piper",
			args = {
				'cd "$1" && LS_COLORS="ex=32" eza -lbF --tree --level 1 --color=always --icons=always --group-directories-first --no-quotes .',
			},
		},
		eza_tree_2 = {
			previewer = "piper",
			args = {
				'cd "$1" && LS_COLORS="ex=32" eza -lbF --tree --level 2 --color=always --icons=always --group-directories-first --no-quotes .',
			},
		},
		eza_tree_3 = {
			previewer = "piper",
			args = {
				'cd "$1" && LS_COLORS="ex=32" eza -lbF --tree --level 3 --color=always --icons=always --group-directories-first --no-quotes .',
			},
		},
		eza_tree_4 = {
			previewer = "piper",
			args = {
				'cd "$1" && LS_COLORS="ex=32" eza -lbF --tree --level 4 --color=always --icons=always --group-directories-first --no-quotes .',
			},
		},
	},
})
