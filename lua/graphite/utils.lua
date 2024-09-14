local M = {}

function M.execute_command(command, args)
	local cmd = vim.g.graphite_executable .. " " .. command

	if args then
		cmd = cmd .. " " .. table.concat(args, " ")
	end

	local output = vim.fn.system(cmd)

	-- Create a new buffer to display the output
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))

	-- Open the buffer in a new window
	vim.api.nvim_command("vsplit")
	vim.api.nvim_win_set_buf(0, buf)

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

function M.parse_flags(args)
	local flags = {}
	local positional = {}

	for _, arg in ipairs(args) do
		if arg:sub(1, 2) == "--" then
			local flag, value = arg:match("^%-%-([^=]+)=?(.*)$")
			flags[flag] = value ~= "" and value or true
		else
			table.insert(positional, arg)
		end
	end

	return flags, positional
end

return M
