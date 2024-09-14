local utils = require("graphite.utils")
local M = {}

function M.show(args)
	utils.execute_command("log", args)
end

function M.show_short(args)
	utils.execute_command("log short", args)
end

function M.show_long(args)
	utils.execute_command("log long", args)
end

return M
