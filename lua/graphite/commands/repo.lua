local utils = require("graphite.utils")
local M = {}

function M.init()
	utils.execute_command("repo init")
end

function M.name(args)
	utils.execute_command("repo name", args)
end

function M.owner(args)
	utils.execute_command("repo owner", args)
end

function M.pr_templates(args)
	utils.execute_command("repo pr-templates", args)
end

function M.remote(args)
	utils.execute_command("repo remote", args)
end

function M.sync()
	utils.execute_command("repo sync")
end

return M
