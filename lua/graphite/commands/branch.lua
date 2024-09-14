local utils = require("graphite.utils")
local M = {}

function M.create(args)
	utils.execute_command("branch create", args)
end

function M.checkout(args)
	utils.execute_command("branch checkout", args)
end

function M.up()
	utils.execute_command("branch up")
end

function M.down()
	utils.execute_command("branch down")
end

function M.top()
	utils.execute_command("branch top")
end

function M.bottom()
	utils.execute_command("branch bottom")
end

function M.info()
	utils.execute_command("branch info")
end

function M.delete(args)
	utils.execute_command("branch delete", args)
end

function M.rename(args)
	utils.execute_command("branch rename", args)
end

function M.restack()
	utils.execute_command("branch restack")
end

function M.split(args)
	utils.execute_command("branch split", args)
end

function M.squash(args)
	utils.execute_command("branch squash", args)
end

function M.submit()
	utils.execute_command("branch submit")
end

function M.track(args)
	utils.execute_command("branch track", args)
end

function M.untrack(args)
	utils.execute_command("branch untrack", args)
end

function M.unbranch()
	utils.execute_command("branch unbranch")
end

return M
