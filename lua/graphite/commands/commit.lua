local utils = require("graphite.utils")
local M = {}

function M.create(args)
	utils.execute_command("commit create", args)
end

function M.amend()
	utils.execute_command("commit amend")
end

return M
