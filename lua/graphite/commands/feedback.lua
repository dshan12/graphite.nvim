local utils = require("graphite.utils")
local M = {}

function M.send(args)
	utils.execute_command("feedback", args)
end

function M.debug_context()
	utils.execute_command("debug-context")
end

return M
