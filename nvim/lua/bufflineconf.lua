require("bufferline").setup({})

local bufferline = require("bufferline")
bufferline.setup({
	options = {
		separator_style = "slant",
		diagnostics = "nvim_lsp",
		custom_filter = function(buf, buf_nums)
			return not vim.fn.bufname(buf):match(":zsh")
		end,
		offsets = {
			{
				filetype = "neo-tree",
				text = "NeoTree",
				text_align = "left",
				separator = true,
			},
		},
	},
})
