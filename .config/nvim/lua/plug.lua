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
    { "williamboman/mason-lspconfig.nvim" },

    -- Configurations for LSP servers
    -- Completed: Mon 26 Feb, 2024
    { "neovim/nvim-lspconfig" },

    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
    },

    -- none-ls
    -- Completed: Tue 27 Feb, 2024
    {
        "nvimtools/none-ls.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    { "nvimtools/none-ls-extras.nvim" },

    -- treesitter: Highlighting
    -- Completed: Mon 26 Feb, 2024
    {
        "nvim-treesitter/nvim-treesitter",
        --build = ":TSUpdate",
    },
    -- treesitter context: Highlighting which context/indent you are in
    -- if context is out of screen
    -- Completed: Mon 26 Feb, 2024
    { "nvim-treesitter/nvim-treesitter-context" },

    -- Todo Highlighting
    -- For some reason it doesn't work in `init_plug`, and I'm too lazy
    -- to figure out why
    -- Completed: Mon 26 Feb, 2024
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

    -- Telescope
    -- Updated: 2023-10-30
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
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
    -- Headline Highlighting
    -- Completed: Mon 25 Mar, 2024
    {
        "lukas-reineke/headlines.nvim",
        after = "nvim-treesitter",
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

    -- Theme
    -- Completed: Tue 27 Feb, 2024
    { "navarasu/onedark.nvim" },
    -- Other Theme
    -- Completed: Tue 27 Feb, 2024
    { "sainnhe/edge" },
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
    -- TempleOS Theme
    { "LunarVim/templeos.nvim" },

    --- Git ---
    -- Git Diff
    -- Completed: Wed 31 May, 2023
    { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },
    -- Git change visualiser
    -- Completed: Mon 26 Feb, 2024
    {
        "lewis6991/gitsigns.nvim",
        tag = "release",
    },
    -- Open in remote
    -- Completed: Mon 26 Feb, 2024
    { "ruanyl/vim-gh-line" },

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

    -- Snacks
    { "folke/snacks.nvim" },

    config = {
        package_root = vim.fn.stdpath("config") .. "/site/pack",
    },
})
