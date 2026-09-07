return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{
			"<leader>dv",
			function()
				if require("diffview.lib").get_current_view() then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen")
				end
			end,
			desc = "Toggle Diffview",
		},
		{ "<leader>dm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff against main" },
		{
			"<leader>dr",
			function()
				vim.ui.input({ prompt = "Branch: ", default = "origin/" }, function(branch)
					if branch and branch ~= "" then
						vim.cmd("DiffviewOpen " .. branch .. "...HEAD")
					end
				end)
			end,
			desc = "Diff against branch",
		},
		{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
	},
	opts = {},
}
