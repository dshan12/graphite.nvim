local utils = require("graphite.utils")
local M = {}

function M.edit(args)
	utils.execute_command("downstack edit", args)
end

function M.get(args)
	utils.execute_command("downstack get", args)
end

function M.restack()
	utils.execute_command("downstack restack")
end

function M.submit()
	utils.execute_command("downstack submit")
end

function M.test()
	utils.execute_command("downstack test")
end

function M.track(args)
	utils.execute_command("downstack track", args)
end

return M
