-- [[ plug.lua ]]

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup({
	function(use)
		-- [[ Plugins Go Here ]]
		-- Packer
		-- Completed (sortof): Wed 31 May, 2023
		use({
			"wbthomason/packer.nvim",
		})
		-- [[ Core functionality ]]
		-- lspconfigs
		-- Completed: Thu 01 Jun, 2023
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		})
		-- Completed: Thu 01 Jun, 2023
		use({
			"neovim/nvim-lspconfig",
		})
		-- cmp
		-- Completed (Sortof): Thu 01 Jun, 2023
		use({
			"hrsh7th/nvim-cmp",
		})
		-- cmp - lsp connection
		-- Completed: Thu 01 Jun, 2023
		use({ "hrsh7th/cmp-nvim-lsp" })
		-- cmp - lsp signature helper
		-- Completed: Thu 01 Jun, 2023
		use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
		-- cmp - snippet connection
		-- Completed: Thu 01 Jun, 2023
		use({ "saadparwaiz1/cmp_luasnip" })
		-- Completed (Sortof): Wed 31 May, 2023
		use({
			"L3MON4D3/LuaSnip",
			requires = { "rafamadriz/friendly-snippets" },
			run = "make install_jsregexp",
		})
		-- autopairs for cmp
		use({ "windwp/nvim-autopairs" })
		-- null-ls
		-- Completed: Wed 31 May, 2023
		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
		})
		-- treesitter: Highlighting
		-- Completed: Wed 31 May, 2023
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
		})
		-- treesitter context: Highlighting which context/indent you are in
		-- if context is out of screen
		-- Completed: Wed 31 May, 2023
		use({
			"nvim-treesitter/nvim-treesitter-context",
		})
		--- filesystem navigation
		-- Completed: Wed 31 May, 2023
		use({
			"nvim-tree/nvim-tree.lua",
			requires = "nvim-tree/nvim-web-devicons",
		})
		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			tag = "0.1.1",
			requires = { { "nvim-lua/plenary.nvim" } },
		})
		-- find key used for action
		-- Completed: Wed 31 May, 2023
		use({
			"folke/which-key.nvim",
			config = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
				require("which-key").setup({})
			end,
		})

		--- Useful macros
		-- Show trouble
		-- Completed: Wed 31 May, 2023
		use({
			"folke/trouble.nvim",
			requires = "nvim-tree/nvim-web-devicons",
		})
		-- nvim-surround
		-- Completed: Wed 31 May, 2023
		use({
			"kylechui/nvim-surround",
		})

		--- Visual
		-- Completed (but can be further riced): Wed 31 May, 2023
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "nvim-tree/nvim-web-devicons", opt = true },
		})
		-- Top buffer tab line
		-- Completed: Wed 31 May, 2023
		use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })
		-- Theme
		-- Completed: Wed 31 May, 2023
		use({ "navarasu/onedark.nvim" })
		-- File structure view
		-- Completed: Wed 31 May, 2023
		use({
			"stevearc/aerial.nvim",
		})
		-- Notifications
		-- Completed: Wed 31 May, 2023
		use({
			"rcarriga/nvim-notify",
		})
		-- Indent lines
		-- Completed: Wed 31 May, 2023
		use({ "lukas-reineke/indent-blankline.nvim" })
		-- CSV
		use({ "chrisbra/csv.vim" })

		--- Git
		-- Git Diff
		-- Completed: Wed 31 May, 2023
		use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
		-- Git change visualiser
		-- Completed: Wed 31 May, 2023
		use({
			"lewis6991/gitsigns.nvim",
			tag = "release",
		})

		--- Tools
		-- Testing
		-- Completed: Wed 31 May, 2023
		use({
			"vim-test/vim-test",
		})
		-- Tmux interaction, only used for vim-test
		-- Completed: Wed 31 May, 2023
		use({
			"preservim/vimux",
		})

		--- Varia
		use({
			"renerocksai/telekasten.nvim",
			requires = { "nvim-telescope/telescope.nvim" },
		})
		use({
			"ellisonleao/glow.nvim",
		})
		-- Bookmarks
		-- Completed: Wed 31 May, 2023
		use({
			"MattesGroeger/vim-bookmarks",
		})
		-- Completed: Wed 31 May, 2023
		use({
			"tom-anders/telescope-vim-bookmarks.nvim",
		})
		-- Open in remote
		use({ "ruanyl/vim-gh-line" })
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		package_root = vim.fn.stdpath("config") .. "/site/pack",
	},
})
