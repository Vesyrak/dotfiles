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
        -- Packer
        -- Completed: Wed 31 May, 2023
        use({
            "wbthomason/packer.nvim",
        })

        --- Core functionality
        -- lspconfigs
        -- Completed: Thu 01 Jun, 2023
        use({
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        })
        -- Configurations for LSP servers
        -- Completed: Thu 01 Jun, 2023
        use({
            "neovim/nvim-lspconfig",
        })

        -- AutoComplete
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

        -- Snippets
        -- Completed (Sortof): Wed 31 May, 2023
        use({
            "L3MON4D3/LuaSnip",
            requires = { "rafamadriz/friendly-snippets" },
            run = "make install_jsregexp",
        })
        use({ "ray-x/lsp_signature.nvim" })

        -- autopairs for cmp
        -- use({ "windwp/nvim-autopairs" })

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

        --- Navigation
        -- Tree sidebar
        -- Completed: Wed 31 May, 2023
        use({
            "nvim-tree/nvim-tree.lua",
            requires = "nvim-tree/nvim-web-devicons",
        })

        -- Telescope
        use({
            "nvim-telescope/telescope.nvim",
            tag = "0.1.2",
            requires = { { "nvim-lua/plenary.nvim" } },
        })

        -- Find key used for action
        -- Completed: Wed 31 May, 2023
        use({
            "folke/which-key.nvim",
            config = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require("which-key").setup({})
            end,
        })
        -- File structure view
        -- Completed: Wed 31 May, 2023
        use({
            "stevearc/aerial.nvim",
        })
        -- Bookmarks
        use({
            "crusj/bookmarks.nvim",
        })

        --- Useful macros
        -- Show errors
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
        -- Comment
        use({ "numToStr/Comment.nvim" })

        --- Visual
        -- Illuminate same words
        -- Completed: 2023-08-23
        use({ "RRethy/vim-illuminate" })
        -- Wildmenu rice
        -- Completed: 2023-08-23
        use({
            "gelguy/wilder.nvim",
        })
        -- Lualine
        -- Completed (but can be further riced): Wed 31 May, 2023
        use({
            "nvim-lualine/lualine.nvim",
            requires = { "nvim-tree/nvim-web-devicons", opt = true },
        })
        -- Zen Mode
        -- Completed: 2023-08-22 09:23
        use({
            "folke/zen-mode.nvim",
            opts = {
                kitty = {
                    enabled = true,
                    font = "+4", -- font size increment
                },
            },
        })
        -- Theme
        -- Completed: Wed 31 May, 2023
        use({ "navarasu/onedark.nvim" })
        -- Other Theme
        -- Completed: 2023-08-22 09:08
        use({ "sainnhe/edge" })
        -- Notifications
        -- Completed: Wed 31 May, 2023
        use({
            "rcarriga/nvim-notify",
        })
        -- Indent lines
        -- Completed: Wed 31 May, 2023
        use({ "lukas-reineke/indent-blankline.nvim" })

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
        -- Open in remote
        use({ "ruanyl/vim-gh-line" })

        --- Tools
        -- Align
        use({ "junegunn/vim-easy-align" })
        -- Oil
        use({
            "stevearc/oil.nvim",
        })
        use({
            "nvim-telescope/telescope-fzf-native.nvim",
            run =
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        })

        -- Testing
        -- Completed: 2023-08-23
        use({
            "nvim-neotest/neotest",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-neotest/neotest-python",
                "nvim-neotest/neotest-plenary",
            },
        })
        -- Neotest recommends it?
        use({ "folke/neodev.nvim" })
        -- Tmux interaction, only used for vim-test
        -- Completed: Wed 31 May, 2023
        use({
            "preservim/vimux",
        })

        -- Refactoring
        use({
            "ThePrimeagen/refactoring.nvim",
            requires = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-treesitter/nvim-treesitter" },
            },
        })

        --- Varia
        -- Show markdown
        -- Completed: 2023-08-20 21:45
        use({
            "ellisonleao/glow.nvim",
        })
        -- QMK Formatter
        use({
            "codethread/qmk.nvim",
        })
        -- Undotree
        use({
            "mbbill/undotree",
        })

        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        package_root = vim.fn.stdpath("config") .. "/site/pack",
    },
})
