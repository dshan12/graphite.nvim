local api = vim.api
local utils = require("graphite.utils")
local M = {}
local is_refreshing = false

local function make_title_line(title, width)
	return " " .. title .. string.rep(" ", math.max(0, width - 2 - #title - 1))
end

local function create_pane(width, height, row, col, title, container_win)
	local buf = api.nvim_create_buf(false, true)
	local win = api.nvim_open_win(buf, false, {
		style = "minimal",
		relative = "win",
		win = container_win,
		width = width,
		height = height,
		row = row,
		col = col,
		border = "single",
	})
	api.nvim_buf_set_option(buf, "modifiable", true)
	api.nvim_buf_set_lines(buf, 0, -1, false, { make_title_line(title, width) })
	api.nvim_buf_set_option(buf, "modifiable", false)
	api.nvim_win_set_option(win, "winhighlight", "NormalFloat:NormalFloat")
	return buf, win
end

function M.create_dashboard()
	local screen_w = api.nvim_get_option("columns")
	local screen_h = api.nvim_get_option("lines")

	local dash_w = math.floor(screen_w * 0.85)
	local dash_h = math.floor(screen_h * 0.8)
	local dash_row = math.floor((screen_h - dash_h) / 2)
	local dash_col = math.floor((screen_w - dash_w) / 2)

	local main_buf = api.nvim_create_buf(false, true)
	local main_win = api.nvim_open_win(main_buf, true, {
		style = "minimal",
		relative = "editor",
		width = dash_w,
		height = dash_h,
		row = dash_row,
		col = dash_col,
		border = "rounded",
		title = " Graphite Dashboard ",
		title_pos = "center",
	})

	api.nvim_buf_set_option(main_buf, "modifiable", false)

	local half_w = math.floor((dash_w - 3) / 2)
	local half_h = math.floor((dash_h - 3) / 2)

	local branches_buf, branches_win = create_pane(half_w, half_h, 0, 0, "Branches", main_win)
	local status_buf, status_win = create_pane(half_w, half_h, 0, half_w + 1, "Status", main_win)
	local commits_buf, commits_win = create_pane(half_w, half_h, half_h + 1, 0, "Commits", main_win)
	local diff_buf, diff_win = create_pane(half_w, half_h, half_h + 1, half_w + 1, "Diff", main_win)

	M.buffers = {
		main = main_buf,
		branches = branches_buf,
		commits = commits_buf,
		status = status_buf,
		diff = diff_buf,
	}
	M.windows = {
		main = main_win,
		branches = branches_win,
		commits = commits_win,
		status = status_win,
		diff = diff_win,
	}

	api.nvim_buf_set_keymap(main_buf, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			M.close_dashboard()
		end,
	})
	api.nvim_buf_set_keymap(main_buf, "n", "r", "", {
		noremap = true,
		silent = true,
		callback = function()
			M.refresh_dashboard()
		end,
	})
	api.nvim_buf_set_keymap(main_buf, "n", "<Tab>", "", {
		noremap = true,
		silent = true,
		callback = function()
			M.next_window()
		end,
	})
	api.nvim_buf_set_keymap(main_buf, "n", "<S-Tab>", "", {
		noremap = true,
		silent = true,
		callback = function()
			M.prev_window()
		end,
	})

	M.setup_branch_keymaps(branches_buf)
	M.setup_commit_keymaps(commits_buf)
	M.setup_diff_keymaps(diff_buf)

	M.refresh_dashboard()
end

function M.setup_branch_keymaps(buf)
	api.nvim_buf_set_keymap(buf, "n", "c", ':lua require("graphite.commands.branch").create()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "C", ':lua require("graphite.commands.branch").checkout()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "d", ':lua require("graphite.commands.branch").delete()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "s", ':lua require("graphite.commands.branch").submit()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "r", ':lua require("graphite.commands.branch").restack()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "j", "", {
		noremap = true,
		silent = true,
		callback = function()
			local cursor = api.nvim_win_get_cursor(0)
			api.nvim_win_set_cursor(0, { cursor[1] + 1, cursor[2] })
			M.show_branch_detail()
		end,
	})
	api.nvim_buf_set_keymap(buf, "n", "k", "", {
		noremap = true,
		silent = true,
		callback = function()
			local cursor = api.nvim_win_get_cursor(0)
			api.nvim_win_set_cursor(0, { math.max(1, cursor[1] - 1), cursor[2] })
			M.show_branch_detail()
		end,
	})
end

function M.setup_commit_keymaps(buf)
	api.nvim_buf_set_keymap(buf, "n", "c", ':lua require("graphite.commands.commit").create()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "a", ':lua require("graphite.commands.commit").amend()<CR>', {
		noremap = true,
		silent = true,
	})
end

function M.setup_diff_keymaps(buf)
	api.nvim_buf_set_keymap(buf, "n", "a", ':lua require("graphite.commands.diff").apply()<CR>', {
		noremap = true,
		silent = true,
	})
	api.nvim_buf_set_keymap(buf, "n", "r", ':lua require("graphite.commands.diff").reset()<CR>', {
		noremap = true,
		silent = true,
	})
end

local function set_content(buf, lines)
	if not buf or not api.nvim_buf_is_valid(buf) then
		return
	end
	api.nvim_buf_set_option(buf, "modifiable", true)
	local existing = api.nvim_buf_line_count(buf)
	api.nvim_buf_set_lines(buf, 1, existing, false, lines)
	api.nvim_buf_set_option(buf, "modifiable", false)
end

function M.refresh_dashboard()
	if is_refreshing then
		return
	end
	is_refreshing = true

	local branches = M.get_branches()
	set_content(M.buffers.branches, branches)

	local commits = M.get_commits()
	set_content(M.buffers.commits, commits)

	local status = M.get_status()
	set_content(M.buffers.status, status)

	local diff = M.get_diff()
	set_content(M.buffers.diff, diff)

	is_refreshing = false
end

function M.show_branch_detail()
	local current = api.nvim_get_current_win()
	if current ~= M.windows.branches then
		return
	end
	local buf = api.nvim_get_current_buf()
	local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
	local cursor = api.nvim_win_get_cursor(0)
	local line_idx = cursor[1]
	if line_idx >= 2 and line_idx <= #lines then
		local branch_name = lines[line_idx]:match("^%s*(%S+)")
		if branch_name then
			local info = utils.get_command_output("branch info", { branch_name })
			set_content(M.buffers.status, info)
		end
	end
end

function M.close_dashboard()
	for _, win in pairs(M.windows) do
		if win and api.nvim_win_is_valid(win) then
			api.nvim_win_close(win, true)
		end
	end
	M.buffers = {}
	M.windows = {}
end

local function content_windows()
	return { M.windows.branches, M.windows.commits, M.windows.status, M.windows.diff }
end

function M.next_window()
	local current = api.nvim_get_current_win()
	local wins = content_windows()
	for i, win in ipairs(wins) do
		if win == current then
			local next_win = wins[(i % #wins) + 1]
			if next_win and api.nvim_win_is_valid(next_win) then
				api.nvim_set_current_win(next_win)
			end
			return
		end
	end
end

function M.prev_window()
	local current = api.nvim_get_current_win()
	local wins = content_windows()
	for i, win in ipairs(wins) do
		if win == current then
			local prev = wins[((i - 2) % #wins) + 1]
			if prev and api.nvim_win_is_valid(prev) then
				api.nvim_set_current_win(prev)
			end
			return
		end
	end
end

function M.get_branches()
	local lines = utils.get_command_output("branch list")
	if #lines == 0 then
		return { "  No branches found" }
	end
	return vim.tbl_map(function(line)
		return "  " .. line
	end, lines)
end

function M.get_commits()
	local lines = utils.get_command_output("log", { "--limit", "10" })
	if #lines == 0 then
		return { "  No commits found" }
	end
	return vim.tbl_map(function(line)
		return "  " .. line
	end, lines)
end

function M.get_status()
	local lines = utils.get_command_output("status")
	if #lines == 0 then
		return { "  Clean working tree" }
	end
	return vim.tbl_map(function(line)
		return "  " .. line
	end, lines)
end

function M.get_diff()
	local lines = utils.get_command_output("diff")
	if #lines == 0 then
		return { "  No changes" }
	end
	return vim.tbl_map(function(line)
		return "  " .. line
	end, lines)
end

return M
