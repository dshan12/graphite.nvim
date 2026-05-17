local M = {}

function M.build_cmd(command, args)
	local exe = vim.g.graphite_executable or "gt"
	local cmd = exe .. " " .. command
	if args and #args > 0 then
		cmd = cmd .. " " .. table.concat(args, " ")
	end
	return cmd
end

function M.get_command_output(command, args)
	local cmd = M.build_cmd(command, args)
	local output = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return {}
	end
	local lines = vim.split(output, "\n")
	if #lines > 0 and lines[#lines] == "" then
		table.remove(lines)
	end
	return lines
end

function M.execute_command(command, args)
	local cmd = M.build_cmd(command, args)
	local output = vim.fn.system(cmd)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))

	vim.api.nvim_command("vsplit")
	vim.api.nvim_win_set_buf(0, buf)

	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

return M
