local api = vim.api
local M = {}

local function create_win(width, height, row, col)
	local buf = api.nvim_create_buf(false, true)
	local win = api.nvim_open_win(buf, true, {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
	})
	return buf, win
end

local function set_lines(buf, lines)
	api.nvim_buf_set_option(buf, "modifiable", true)
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	api.nvim_buf_set_option(buf, "modifiable", false)
end

local function set_keymap(buf, key, command)
	api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
end

function M.create_dashboard()
	local width = api.nvim_get_option("columns")
	local height = api.nvim_get_option("lines")

	-- Create main window
	local main_buf, main_win = create_win(width, height, 0, 0)

	-- Create left panel (30% width)
	local left_width = math.floor(width * 0.3)
	local left_buf, left_win = create_win(left_width, height, 0, 0)

	-- Create right panel (70% width)
	local right_width = width - left_width
	local right_buf, right_win = create_win(right_width, height, 0, left_width)

	-- Populate left panel
	local left_content = {
		"Graphite Dashboard",
		"",
		"Branches:",
		"  * main",
		"    feature/new-dashboard",
		"    bugfix/issue-123",
		"",
		"Commands:",
		"  b - Branch operations",
		"  c - Commit operations",
		"  s - Stack operations",
		"  l - Log",
		"  q - Quit",
	}
	set_lines(left_buf, left_content)

	-- Populate right panel (example content)
	local right_content = {
		"Current Branch: main",
		"",
		"Recent Commits:",
		"  abc1234 Update dashboard layout",
		"  def5678 Fix bug in branch creation",
		"  ghi9012 Implement new feature",
		"",
		"Status:",
		"  2 files changed, 15 insertions(+), 5 deletions(-)",
		"",
		"Press 'r' to refresh",
	}
	set_lines(right_buf, right_content)

	-- Set up keymaps
	set_keymap(left_buf, "b", ':lua require("graphite.ui.dashboard").show_branch_menu()<CR>')
	set_keymap(left_buf, "c", ':lua require("graphite.ui.dashboard").show_commit_menu()<CR>')
	set_keymap(left_buf, "s", ':lua require("graphite.ui.dashboard").show_stack_menu()<CR>')
	set_keymap(left_buf, "l", ":GraphiteLog<CR>")
	set_keymap(left_buf, "q", ":qa<CR>")
	set_keymap(right_buf, "r", ':lua require("graphite.ui.dashboard").refresh_right_panel()<CR>')

	-- Set options
	api.nvim_win_set_option(left_win, "cursorline", true)
	api.nvim_win_set_option(right_win, "cursorline", true)

	-- Store buffers and windows for later use
	M.main_buf, M.main_win = main_buf, main_win
	M.left_buf, M.left_win = left_buf, left_win
	M.right_buf, M.right_win = right_buf, right_win
end

function M.refresh_right_panel()
	-- This function should update the content of the right panel
	-- You can call Graphite commands here and update the panel with the results
	local content = {
		"Current Branch: feature/new-dashboard",
		"",
		"Recent Commits:",
		"  jkl3456 Implement dashboard refresh",
		"  abc1234 Update dashboard layout",
		"  def5678 Fix bug in branch creation",
		"",
		"Status:",
		"  1 file changed, 50 insertions(+), 10 deletions(-)",
		"",
		"Press 'r' to refresh",
	}
	set_lines(M.right_buf, content)
end

function M.show_branch_menu()
	local menu_items = {
		"1. Create branch",
		"2. Checkout branch",
		"3. Branch up",
		"4. Branch down",
		"5. Branch top",
		"6. Branch bottom",
		"7. Branch info",
		"8. Delete branch",
		"9. Rename branch",
		"10. Restack branch",
		"11. Split branch",
		"12. Squash branch",
		"13. Submit branch",
		"14. Track branch",
		"15. Untrack branch",
		"16. Unbranch",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteBranchCreate",
		"GraphiteBranchCheckout",
		"GraphiteBranchUp",
		"GraphiteBranchDown",
		"GraphiteBranchTop",
		"GraphiteBranchBottom",
		"GraphiteBranchInfo",
		"GraphiteBranchDelete",
		"GraphiteBranchRename",
		"GraphiteBranchRestack",
		"GraphiteBranchSplit",
		"GraphiteBranchSquash",
		"GraphiteBranchSubmit",
		"GraphiteBranchTrack",
		"GraphiteBranchUntrack",
		"GraphiteBranchUnbranch",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
		M.refresh_right_panel()
	end
end

function M.show_commit_menu()
	local menu_items = {
		"1. Create commit",
		"2. Amend commit",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteCommitCreate",
		"GraphiteCommitAmend",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
		M.refresh_right_panel()
	end
end

function M.show_stack_menu()
	local menu_items = {
		"1. Restack",
		"2. Submit stack",
		"3. Test stack",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteStackRestack",
		"GraphiteStackSubmit",
		"GraphiteStackTest",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
		M.refresh_right_panel()
	end
end

return M
