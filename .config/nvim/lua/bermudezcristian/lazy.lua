-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find files" },
			{ "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git files" },
			{ "<leader>ps", function()
				require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
			end, desc = "Grep string" },
			{ "<leader>vh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
		},
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd.colorscheme("rose-pine")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c", "lua", "vim", "vimdoc", "query",
					"markdown", "markdown_inline", "javascript", "typescript",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	{
		"theprimeagen/harpoon",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
			vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
			vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
			vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
			vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
		end,
	},

	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gs", vim.cmd.Git, desc = "Git status" },
		},
	},
})
