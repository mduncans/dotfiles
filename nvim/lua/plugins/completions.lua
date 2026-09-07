return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-path",
	},
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	-- Optional but recommended if you want { name = "buffer" } to work:
	{
		"hrsh7th/cmp-buffer",
		-- pin to the "don't use deprecated functions" commit; upstream reverted it
		-- for old-nvim compat, which spams vim.validate deprecation errors on 0.12
		commit = "51f42e6",
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local types = require("cmp.types")

			require("luasnip.loaders.from_vscode").lazy_load()

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				if col == 0 then
					return false
				end
				local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
				return text:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					autocomplete = {
						types.cmp.TriggerEvent.TextChanged,
					},
					keyword_length = 1,
				},
				formatting = {
					fields = { "abbr", "kind" },
					format = function(_, item)
						local max_width = 35

						if #item.abbr > max_width then
							item.abbr = item.abbr:sub(1, max_width - 3) .. "..."
						end

						return item
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						side_padding = 1,
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
					}),
					documentation = cmp.config.window.bordered({
						max_width = 60,
						max_height = 15,
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- ✅ Make Tab / Shift-Tab work like Quarto docs suggest
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif not has_words_before() then
							fallback()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							cmp.complete()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "luasnip" },
				}),
			})
		end,
	},
}
