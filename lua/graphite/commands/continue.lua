local utils = require("graphite.utils")
local M = {}

function M.execute()
	utils.execute_command("continue")
end

return M
