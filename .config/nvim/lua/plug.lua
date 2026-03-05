-- [[ plug.lua ]]

-- Lazy package manager
-- Last updated: 2023-10-30
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    --- Core functionality ---
    -- lspconfigs
    -- Completed: Mon 26 Feb, 2024
    { "williamboman/mason.nvim" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mason-org/mason.nvim",
        },
    },

    -- Configurations for LSP servers
    -- Completed: Mon 26 Feb, 2024
    { "neovim/nvim-lspconfig", dependencies = { "sagnen/blink.cmp" } },

    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = { "rafamadriz/friendly-snippets" },
        lazy = false,
    },

    -- none-ls
    -- Completed: Tue 27 Feb, 2024
    {
        "nvimtools/none-ls.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    { "nvimtools/none-ls-extras.nvim" },

    -- treesitter: Highlighting
    -- Completed: 27/01/2025
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    -- treesitter context: Highlighting which context/indent you are in
    -- if context is out of screen
    -- Completed: 27/01/2025
    { "nvim-treesitter/nvim-treesitter-context" },

    -- Todo Highlighting
    -- Completed: 27/01/2025
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Dynamic Tabstop
    { "tpope/vim-sleuth" },

    --- Navigation ---
    -- Tree sidebar
    -- Completed: Tue 27 Feb, 2024
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
    },

    {
        "folke/edgy.nvim",
        event = "VeryLazy",
    },

    -- Find key used for action
    -- Completed: Mon 26 Feb, 2024
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },
    -- File structure view
    -- Completed: Tue 27 Feb, 2024
    { "stevearc/aerial.nvim" },

    -- Search
    { "MagicDuck/grug-far.nvim" },

    --- Debugging
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

    --- Useful macros ---
    -- Show errors
    -- Completed: Tue 27 Feb, 2024
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    -- nvim-surround
    -- Updated: 2023-10-30
    { "kylechui/nvim-surround" },

    --- Visual ---
    -- Style changing
    {
        "folke/styler.nvim",
    },
    -- Themes
    {
        "paulfrische/reddish.nvim",
    },
    {
        "rebelot/kanagawa.nvim",
    },
    -- Jump window
    {
        "yorickpeterse/nvim-window",
        keys = {
            { "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
        },
        config = true,
    },
    -- Pretty Diagnostics
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000, -- needs to be loaded in first
    },
    -- Illuminate same words
    -- Completed: Tue 27 Feb, 2024
    { "RRethy/vim-illuminate" },
    -- Wildmenu rice
    -- Completed: Mon 26 Feb, 2024
    { "gelguy/wilder.nvim" },
    -- Lualine
    -- Completed (but can be further riced): Wed 31 May, 2023
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    },
    -- Zen Mode
    -- Completed: Wed 28 Feb, 2024
    { "folke/zen-mode.nvim" },

    --- Theme ---
    -- Dark Theme
    -- Completed: Tue 27 Feb, 2024
    { "navarasu/onedark.nvim" },
    -- Green Theme
    -- Completed: Tue 27 Feb, 2024
    { "sainnhe/everforest" },
    -- Purple Theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    --- Git ---
    -- Git Inline diff
    { "echasnovski/mini.diff", version = "*" },
    -- Git Diff
    -- Completed: Wed 31 May, 2023
    { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },
    -- Git change visualiser
    -- Completed: Mon 26 Feb, 2024
    {
        "lewis6991/gitsigns.nvim",
        tag = "release",
    },

    { "tpope/vim-fugitive" },
    -- Fugitive Bitbucket Support
    { "tommcdo/vim-fubitive" },
    -- Fugitive Github Support
    { "tpope/vim-rhubarb" },

    --- Tools ---
    -- Testing
    -- Completed: 2023-08-23
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "folke/neodev.nvim",
            "nvim-neotest/nvim-nio",
        },
    },
    -- Tmux interaction
    -- Updated: 2023-10-30 08:57
    { "preservim/vimux" },

    -- Refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
        },
    },

    --- Varia ---
    -- Calculate inline
    { "sk1418/HowMuch" },

    -- Better Quickfix
    { "kevinhwang91/nvim-bqf" },

    -- Templates
    {
        "glepnir/template.nvim",
        cmd = { "Template", "TemProject" },
        config = function()
            require("template").setup({
                temp_dir = "~/.config/nvim/templates/",
            })
        end,
    },

    -- Undotree
    -- Completed: Mon 26 Feb, 2024
    { "mbbill/undotree" },
    {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },
    -- Snacks
    { "folke/snacks.nvim" },

    --Marks
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Markdown
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    config = {
        package_root = vim.fn.stdpath("config") .. "/site/pack",
    },
    -- Avante AI assistant
    --{
    --    "yetone/avante.nvim",
    --    event = "VeryLazy",
    --    version = false, -- Never set this value to "*"! Never!
    --    build = "make",
    --    dependencies = {
    --        "nvim-treesitter/nvim-treesitter",
    --        "stevearc/dressing.nvim",
    --        "nvim-lua/plenary.nvim",
    --        "MunifTanjim/nui.nvim",
    --    },
    --},
})
