local M = {}

function M.setup(opts)
	opts = opts or {}
	vim.g.graphite_executable = opts.executable or "gt"

	-- Load command modules
	local auth = require("graphite.commands.auth")
	local branch = require("graphite.commands.branch")
	local changelog = require("graphite.commands.changelog")
	local commit = require("graphite.commands.commit")
	local completion = require("graphite.commands.completion")
	local continue = require("graphite.commands.continue")
	local dash = require("graphite.commands.dash")
	local docs = require("graphite.commands.docs")
	local downstack = require("graphite.commands.downstack")
	local feedback = require("graphite.commands.feedback")
	local fish = require("graphite.commands.fish")
	local log = require("graphite.commands.log")
	local repo = require("graphite.commands.repo")
	local stack = require("graphite.commands.stack")
	local upstack = require("graphite.commands.upstack")
	local user = require("graphite.commands.user")

	-- Create user commands
	vim.api.nvim_create_user_command("GraphiteDashboard", function()
		require("graphite.ui.dashboard").create_dashboard()
	end, {})
	vim.api.nvim_create_user_command("GraphiteAuth", function(opts)
		auth.auth(opts.fargs)
	end, { nargs = "*" })

	-- Branch commands
	vim.api.nvim_create_user_command("GraphiteBranchCreate", function(opts)
		branch.create(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchCheckout", function(opts)
		branch.checkout(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchUp", branch.up, {})
	vim.api.nvim_create_user_command("GraphiteBranchDown", branch.down, {})
	vim.api.nvim_create_user_command("GraphiteBranchTop", branch.top, {})
	vim.api.nvim_create_user_command("GraphiteBranchBottom", branch.bottom, {})
	vim.api.nvim_create_user_command("GraphiteBranchInfo", branch.info, {})
	vim.api.nvim_create_user_command("GraphiteBranchDelete", function(opts)
		branch.delete(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchRename", function(opts)
		branch.rename(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchRestack", branch.restack, {})
	vim.api.nvim_create_user_command("GraphiteBranchSplit", function(opts)
		branch.split(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchSquash", function(opts)
		branch.squash(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchSubmit", branch.submit, {})
	vim.api.nvim_create_user_command("GraphiteBranchTrack", function(opts)
		branch.track(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchUntrack", function(opts)
		branch.untrack(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteBranchUnbranch", branch.unbranch, {})

	-- Other commands
	vim.api.nvim_create_user_command("GraphiteChangelog", changelog.show, {})
	vim.api.nvim_create_user_command("GraphiteCommitCreate", function(opts)
		commit.create(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteCommitAmend", commit.amend, {})
	vim.api.nvim_create_user_command("GraphiteCompletion", completion.show, {})
	vim.api.nvim_create_user_command("GraphiteContinue", continue.execute, {})
	vim.api.nvim_create_user_command("GraphiteDash", dash.show, {})
	vim.api.nvim_create_user_command("GraphiteDocs", docs.show, {})

	-- Downstack commands
	vim.api.nvim_create_user_command("GraphiteDownstackEdit", function(opts)
		downstack.edit(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteDownstackGet", function(opts)
		downstack.get(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteDownstackRestack", downstack.restack, {})
	vim.api.nvim_create_user_command("GraphiteDownstackSubmit", downstack.submit, {})
	vim.api.nvim_create_user_command("GraphiteDownstackTest", downstack.test, {})
	vim.api.nvim_create_user_command("GraphiteDownstackTrack", function(opts)
		downstack.track(opts.fargs)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("GraphiteFeedback", function(opts)
		feedback.send(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteDebugContext", feedback.debug_context, {})
	vim.api.nvim_create_user_command("GraphiteFish", fish.execute, {})

	-- Log commands
	vim.api.nvim_create_user_command("GraphiteLog", function(opts)
		log.show(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteLogShort", function(opts)
		log.show_short(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteLogLong", function(opts)
		log.show_long(opts.fargs)
	end, { nargs = "*" })

	-- Repo commands
	vim.api.nvim_create_user_command("GraphiteRepoInit", repo.init, {})
	vim.api.nvim_create_user_command("GraphiteRepoName", function(opts)
		repo.name(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteRepoOwner", function(opts)
		repo.owner(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteRepoPRTemplates", function(opts)
		repo.pr_templates(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteRepoRemote", function(opts)
		repo.remote(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteRepoSync", repo.sync, {})

	-- Stack commands
	vim.api.nvim_create_user_command("GraphiteStackRestack", stack.restack, {})
	vim.api.nvim_create_user_command("GraphiteStackSubmit", stack.submit, {})
	vim.api.nvim_create_user_command("GraphiteStackTest", stack.test, {})

	-- Upstack commands
	vim.api.nvim_create_user_command("GraphiteUpstackOnto", function(opts)
		upstack.onto(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteUpstackRestack", upstack.restack, {})
	vim.api.nvim_create_user_command("GraphiteUpstackSubmit", upstack.submit, {})
	vim.api.nvim_create_user_command("GraphiteUpstackTest", upstack.test, {})

	-- User commands
	vim.api.nvim_create_user_command("GraphiteUserBranchDate", function(opts)
		user.branch_date(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteUserBranchPrefix", function(opts)
		user.branch_prefix(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteUserBranchReplacement", function(opts)
		user.branch_replacement(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteUserEditor", function(opts)
		user.editor(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteUserPager", function(opts)
		user.pager(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteUserRestackDate", function(opts)
		user.restack_date(opts.fargs)
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("GraphiteUserSubmitBody", function(opts)
		user.submit_body(opts.fargs)
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("GraphiteUserTips", user.tips, {})

	-- Set up keymaps
	vim.api.nvim_set_keymap("n", "<leader>gd", ":GraphiteDashboard<CR>", { noremap = true, silent = true })
end

function M.open_dashboard()
	local dashboard = require("graphite.ui.dashboard")
	dashboard.create_dashboard()
end

return M
