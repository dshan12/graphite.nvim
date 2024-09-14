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

	local function add_line(text)
		api.nvim_buf_set_lines(buf, -1, -1, false, { text })
	end

	-- Clear buffer
	api.nvim_buf_set_lines(buf, 0, -1, false, {})

	-- Add ASCII art title
	add_line(
		"  ██████╗ ██████╗  █████╗ ██████╗ ██╗  ██╗██╗████████╗███████╗"
	)
	add_line(
		" ██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██║  ██║██║╚══██╔══╝██╔════╝"
	)
	add_line(
		" ██║  ███╗██████╔╝███████║██████╔╝███████║██║   ██║   █████╗  "
	)
	add_line(
		" ██║   ██║██╔══██╗██╔══██║██╔═══╝ ██╔══██║██║   ██║   ██╔══╝  "
	)
	add_line(
		" ╚██████╔╝██║  ██║██║  ██║██║     ██║  ██║██║   ██║   ███████╗"
	)
	add_line(
		"  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝"
	)
	add_line("")
	add_line("Welcome to Graphite Dashboard")
	add_line("")

	-- Add command sections
	local sections = {
		{
			title = "Branch Operations",
			key = "b",
			items = {
				{ key = "c", desc = "Create branch" },
				{ key = "h", desc = "Checkout branch" },
				{ key = "i", desc = "Branch info" },
				{ key = "d", desc = "Delete branch" },
				{ key = "r", desc = "Rename branch" },
				{ key = "s", desc = "Submit branch" },
			},
		},
		{
			title = "Commit Operations",
			key = "c",
			items = {
				{ key = "c", desc = "Create commit" },
				{ key = "a", desc = "Amend commit" },
			},
		},
		{
			title = "Stack Operations",
			key = "s",
			items = {
				{ key = "r", desc = "Restack" },
				{ key = "s", desc = "Submit stack" },
				{ key = "t", desc = "Test stack" },
			},
		},
		{
			title = "Other Commands",
			key = "o",
			items = {
				{ key = "l", desc = "Log" },
				{ key = "a", desc = "Auth" },
				{ key = "d", desc = "Dash" },
				{ key = "f", desc = "Feedback" },
			},
		},
	}

	for _, section in ipairs(sections) do
		add_line(string.format("  [%s] %s", section.key, section.title))
		for _, item in ipairs(section.items) do
			add_line(string.format("    %s: %s", item.key, item.desc))
		end
		add_line("")
	end

	add_line("Press q to quit")

	-- Set up keymaps
	local function set_keymap(key, command)
		api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
	end

	set_keymap("q", ":q<CR>")
	set_keymap("b", ':lua require("graphite.ui.dashboard").show_branch_menu()<CR>')
	set_keymap("c", ':lua require("graphite.ui.dashboard").show_commit_menu()<CR>')
	set_keymap("s", ':lua require("graphite.ui.dashboard").show_stack_menu()<CR>')
	set_keymap("o", ':lua require("graphite.ui.dashboard").show_other_menu()<CR>')

	-- Set buffer options
	api.nvim_buf_set_option(buf, "modifiable", false)
	api.nvim_win_set_option(win, "cursorline", true)
end

-- Existing menu functions remain the same
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

function M.show_other_menu()
	local menu_items = {
		"1. Log",
		"2. Auth",
		"3. Dash",
		"4. Feedback",
	}

	local choice = vim.fn.inputlist(menu_items)
	local commands = {
		"GraphiteLog",
		"GraphiteAuth",
		"GraphiteDash",
		"GraphiteFeedback",
	}

	if choice > 0 and choice <= #commands then
		vim.cmd(commands[choice])
	end
end

return M
