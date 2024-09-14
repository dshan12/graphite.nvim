local api = vim.api

local M = {}

function M.create_dashboard()
	local buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	local width = api.nvim_get_option("columns")
	local height = api.nvim_get_option("lines")
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = math.ceil((height - win_height) / 2 - 1),
		col = math.ceil((width - win_width) / 2),
	}

	local win = api.nvim_open_win(buf, true, opts)

	local content = {
		"Graphite Dashboard",
		"",
		"Commands:",
		" a - Auth",
		" b - Branch operations",
		" c - Commit operations",
		" d - Downstack operations",
		" l - Log",
		" r - Repo operations",
		" s - Stack operations",
		" u - Upstack operations",
		" q - Quit dashboard",
	}

	api.nvim_buf_set_lines(buf, 0, -1, false, content)

	local function set_keymap(key, command)
		api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
	end

	set_keymap("a", ":GraphiteAuth<CR>")
	set_keymap("b", ':lua require("graphite.ui.dashboard").show_branch_menu()<CR>')
	set_keymap("c", ':lua require("graphite.ui.dashboard").show_commit_menu()<CR>')
	set_keymap("d", ':lua require("graphite.ui.dashboard").show_downstack_menu()<CR>')
	set_keymap("l", ":GraphiteLog<CR>")
	set_keymap("r", ':lua require("graphite.ui.dashboard").show_repo_menu()<CR>')
	set_keymap("s", ':lua require("graphite.ui.dashboard").show_stack_menu()<CR>')
	set_keymap("u", ':lua require("graphite.ui.dashboard").show_upstack_menu()<CR>')
	set_keymap("q", ":q<CR>")

	api.nvim_win_set_option(win, "cursorline", true)
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
	end
end

function M.show_downstack_menu()
	local menu_items = {
		"1. Edit downstack",
		"2. Get downstack",
		"3. Restack downstack",
		"4. Submit downstack",
		"5. Test downstack",
		"6. Track downstack",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteDownstackEdit",
		"GraphiteDownstackGet",
		"GraphiteDownstackRestack",
		"GraphiteDownstackSubmit",
		"GraphiteDownstackTest",
		"GraphiteDownstackTrack",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
	end
end

function M.show_repo_menu()
	local menu_items = {
		"1. Init repo",
		"2. Set repo name",
		"3. Set repo owner",
		"4. Set PR templates",
		"5. Set remote",
		"6. Sync repo",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteRepoInit",
		"GraphiteRepoName",
		"GraphiteRepoOwner",
		"GraphiteRepoPRTemplates",
		"GraphiteRepoRemote",
		"GraphiteRepoSync",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
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
	end
end

function M.show_upstack_menu()
	local menu_items = {
		"1. Onto",
		"2. Restack upstack",
		"3. Submit upstack",
		"4. Test upstack",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteUpstackOnto",
		"GraphiteUpstackRestack",
		"GraphiteUpstackSubmit",
		"GraphiteUpstackTest",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
	end
end

return M
