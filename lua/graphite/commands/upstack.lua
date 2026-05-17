local utils = require("graphite.utils")
local M = {}

function M.onto(args)
	utils.execute_command("upstack onto", args)
end

function M.restack()
	utils.execute_command("upstack restack")
end

function M.submit()
	utils.execute_command("upstack submit")
end

function M.test()
	utils.execute_command("upstack test")
end

return M
