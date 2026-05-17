local utils = require("graphite.utils")
local M = {}

function M.auth(args)
	utils.execute_command("auth", args)
end

return M
