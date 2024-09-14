local utils = require("graphite.utils")
local M = {}

function M.show()
	utils.execute_command("docs")
end

return M
