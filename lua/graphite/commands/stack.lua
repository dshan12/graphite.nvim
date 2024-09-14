local utils = require("graphite.utils")
local M = {}

function M.restack()
	utils.execute_command("stack restack")
end

function M.submit()
	utils.execute_command("stack submit")
end

function M.test()
	utils.execute_command("stack test")
end

return M
