local utils = require("graphite.utils")
local M = {}

function M.apply(args)
	utils.execute_command("diff apply", args)
end

function M.reset(args)
	utils.execute_command("diff reset", args)
end

return M
