local api = vim.api
local M = {}

-- Helper function to create a new window
local function create_win(width, height, row, col, title)
	local buf = api.nvim_create_buf(false, true)
	local win = api.nvim_open_win(buf, false, {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "single",
	})
	api.nvim_buf_set_option(buf, "modifiable", true)
	api.nvim_buf_set_lines(buf, 0, -1, false, { title, string.rep("─", width - 2) })
	api.nvim_buf_set_option(buf, "modifiable", false)
	return buf, win
end

-- Helper function to set content in a buffer
local function set_buf_content(buf, content)
	api.nvim_buf_set_option(buf, "modifiable", true)
	api.nvim_buf_set_lines(buf, 2, -1, false, content)
	api.nvim_buf_set_option(buf, "modifiable", false)
end

function M.create_dashboard()
	local width = api.nvim_get_option("columns")
	local height = api.nvim_get_option("lines")

	-- Create main container
	local main_buf, main_win = create_win(width, height, 0, 0, "Graphite")

	-- Create sub-windows
	local half_width = math.floor(width / 2)
	local half_height = math.floor(height / 2)

	local branches_buf, branches_win = create_win(half_width, half_height - 1, 1, 0, "Branches")
	local commits_buf, commits_win = create_win(half_width, half_height, half_height, 0, "Commits")
	local files_buf, files_win = create_win(half_width, half_height - 1, 1, half_width, "Files")
	local diff_buf, diff_win = create_win(half_width, half_height, half_height, half_width, "Diff")

	-- Store buffers and windows for later use
	M.buffers = {
		main = main_buf,
		branches = branches_buf,
		commits = commits_buf,
		files = files_buf,
		diff = diff_buf,
	}
	M.windows = {
		main = main_win,
		branches = branches_win,
		commits = commits_win,
		files = files_win,
		diff = diff_win,
	}

	-- Set up global keymaps
	local function set_global_keymap(key, command)
		api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
	end

	set_global_keymap("q", ':lua require("graphite.ui.dashboard").close_dashboard()<CR>')
	set_global_keymap("<Tab>", ':lua require("graphite.ui.dashboard").next_window()<CR>')
	set_global_keymap("<S-Tab>", ':lua require("graphite.ui.dashboard").prev_window()<CR>')

	-- Set up pane-specific keymaps
	M.setup_branch_keymaps(branches_buf)
	M.setup_commit_keymaps(commits_buf)
	M.setup_file_keymaps(files_buf)
	M.setup_diff_keymaps(diff_buf)

	-- Initial content population
	M.refresh_dashboard()
end

function M.setup_branch_keymaps(buf)
	local function set_keymap(key, command)
		api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
	end

	set_keymap("c", ':lua require("graphite.commands.branch").create()<CR>')
	set_keymap("d", ':lua require("graphite.commands.branch").delete()<CR>')
	set_keymap("r", ':lua require("graphite.commands.branch").rename()<CR>')
	set_keymap("s", ':lua require("graphite.commands.branch").submit()<CR>')
	-- Add more branch-related keymaps as needed
end

function M.setup_commit_keymaps(buf)
	local function set_keymap(key, command)
		api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
	end

	set_keymap("c", ':lua require("graphite.commands.commit").create()<CR>')
	set_keymap("a", ':lua require("graphite.commands.commit").amend()<CR>')
	-- Add more commit-related keymaps as needed
end

function M.setup_file_keymaps(buf)
	local function set_keymap(key, command)
		api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
	end

	set_keymap("a", ':lua require("graphite.commands.file").add()<CR>')
	set_keymap("r", ':lua require("graphite.commands.file").reset()<CR>')
	-- Add more file-related keymaps as needed
end

function M.setup_diff_keymaps(buf)
	local function set_keymap(key, command)
		api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
	end

	set_keymap("s", ':lua require("graphite.commands.diff").stage_hunk()<CR>')
	set_keymap("u", ':lua require("graphite.commands.diff").unstage_hunk()<CR>')
	-- Add more diff-related keymaps as needed
end

function M.refresh_dashboard()
	-- Populate branches
	local branches = M.get_branches()
	set_buf_content(M.buffers.branches, branches)

	-- Populate commits
	local commits = M.get_commits()
	set_buf_content(M.buffers.commits, commits)

	-- Populate files
	local files = M.get_files()
	set_buf_content(M.buffers.files, files)

	-- Populate diff
	local diff = M.get_diff()
	set_buf_content(M.buffers.diff, diff)
end

function M.close_dashboard()
	for _, win in pairs(M.windows) do
		api.nvim_win_close(win, true)
	end
end

function M.next_window()
	local current_win = api.nvim_get_current_win()
	local windows = vim.tbl_values(M.windows)
	for i, win in ipairs(windows) do
		if win == current_win then
			api.nvim_set_current_win(windows[(i % #windows) + 1])
			return
		end
	end
end

function M.prev_window()
	local current_win = api.nvim_get_current_win()
	local windows = vim.tbl_values(M.windows)
	for i, win in ipairs(windows) do
		if win == current_win then
			api.nvim_set_current_win(windows[((i - 2) % #windows) + 1])
			return
		end
	end
end

-- Helper functions to get data from Graphite
function M.get_branches()
	local output = vim.fn.system(vim.g.graphite_executable .. " branch list")
	return vim.split(output, "\n")
end

function M.get_commits()
	local output = vim.fn.system(vim.g.graphite_executable .. " log --limit 10")
	return vim.split(output, "\n")
end

function M.get_files()
	local output = vim.fn.system(vim.g.graphite_executable .. " status")
	return vim.split(output, "\n")
end

function M.get_diff()
	local output = vim.fn.system(vim.g.graphite_executable .. " diff")
	return vim.split(output, "\n")
end

return M
