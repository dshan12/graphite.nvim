local utils = require("graphite.utils")
local M = {}

function M.branch_date(args)
	utils.execute_command("user branch-date", args)
end

function M.branch_prefix(args)
	utils.execute_command("user branch-prefix", args)
end

function M.branch_replacement(args)
	utils.execute_command("user branch-replacement", args)
end

function M.editor(args)
	utils.execute_command("user editor", args)
end

function M.pager(args)
	utils.execute_command("user pager", args)
end

function M.restack_date(args)
	utils.execute_command("user restack-date", args)
end

function M.submit_body(args)
	utils.execute_command("user submit body", args)
end

function M.tips()
	utils.execute_command("user tips")
end

return M
