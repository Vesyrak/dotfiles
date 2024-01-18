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
    -- Completed: Thu 01 Jun, 2023
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Configurations for LSP servers
    -- Completed: Thu 01 Jun, 2023
    { "neovim/nvim-lspconfig" },

    -- Big Files
    { "LunarVim/bigfile.nvim" },

    -- DAP
    { "mfussenegger/nvim-dap" },
    { "mfussenegger/nvim-dap-python" },
    { "rcarriga/nvim-dap-ui" },
    { "HiPhish/debugpy.nvim" },

    -- AutoComplete
    -- Completed (Sortof): Thu 01 Jun, 2023
    { "hrsh7th/nvim-cmp" },
    -- cmp - lsp connection
    -- Completed: Thu 01 Jun, 2023
    { "hrsh7th/cmp-nvim-lsp" },
    -- cmp - lsp signature helper
    -- Completed: Thu 01 Jun, 2023
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    -- cmp - snippet connection
    -- Completed: Thu 01 Jun, 2023
    { "saadparwaiz1/cmp_luasnip" },

    -- Snippets
    -- Completed (Sortof): Wed 31 May, 2023
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
    },
    { "ray-x/lsp_signature.nvim" },

    -- autopairs for cmp
    -- use({ "windwp/nvim-autopairs" },

    -- none-ls
    -- Completed: 2023-10-30
    {
        "nvimtools/none-ls.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },

    -- treesitter: Highlighting
    -- Completed: Wed 31 May, 2023
    {
        "nvim-treesitter/nvim-treesitter",
        --build = ":TSUpdate",
    },
    -- treesitter context: Highlighting which context/indent you are in
    -- if context is out of screen
    -- Completed: Wed 31 May, 2023
    { "nvim-treesitter/nvim-treesitter-context" },

    --- Navigation ---
    -- Todo List
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- Tree sidebar
    -- Updated: 2023-10-30
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

    -- Find key used for action
    -- Updated: 2023-10-30
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },
    -- File structure view
    -- Updated: 2023-10-30
    { "stevearc/aerial.nvim" },

    --- Useful macros ---
    -- Show errors
    -- Completed: Wed 31 May, 2023
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    -- nvim-surround
    -- Updated: 2023-10-30
    { "kylechui/nvim-surround" },
    -- Comment
    { "numToStr/Comment.nvim" },

    --- Visual ---
    -- Illuminate same words
    -- Completed: 2023-08-23
    { "RRethy/vim-illuminate" },
    -- Wildmenu rice
    -- Completed: 2023-08-23
    { "gelguy/wilder.nvim" },
    -- Lualine
    -- Completed (but can be further riced): Wed 31 May, 2023
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    },
    -- Zen Mode
    -- Completed: 2023-08-22 09:23
    {
        "folke/zen-mode.nvim",
        opts = {
            kitty = {
                enabled = true,
                font = "+4", -- font size increment
            },
        },
    },
    -- Theme
    -- Completed: Wed 31 May, 2023
    { "navarasu/onedark.nvim" },
    -- Other Theme
    -- Completed: 2023-08-22 09:08
    { "sainnhe/edge" },
    -- Green Theme
    { "sainnhe/everforest" },
    -- Purple Theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- Notifications
    -- Updated: 2023-10-30 09:02
    { "rcarriga/nvim-notify" },

    -- Indent lines
    -- Completed: 2023-10-30
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },

    --- Git ---
    -- Git Diff
    -- Completed: Wed 31 May, 2023
    { "sindrets/diffview.nvim",              dependencies = "nvim-lua/plenary.nvim" },
    -- Git change visualiser
    -- Completed: Wed 31 May, 2023
    {
        "lewis6991/gitsigns.nvim",
        tag = "release",
    },
    -- Open in remote
    -- Completed: 2023-08-28
    { "ruanyl/vim-gh-line" },

    --- Tools ---
    -- Oil
    -- Completed: 2023-08-28
    { "stevearc/oil.nvim" },

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
    -- Start Screen
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    -- LLM
    {
        "gsuuon/model.nvim",
        cmd = { "M", "Model", "Mchat" },
        init = function()
            vim.filetype.add({
                extension = {
                    mchat = "mchat",
                },
            })
        end,
        ft = "mchat",

        keys = {
            { "<C-m>d",       ":Mdelete<cr>", mode = "n" },
            { "<C-m>s",       ":Mselect<cr>", mode = "n" },
            { "<C-m><space>", ":Mchat<cr>",   mode = "n" },
        },
    },
    -- Show markdown
    -- Completed: 2023-08-20 21:45
    { "ellisonleao/glow.nvim" },
    -- Undotree
    { "mbbill/undotree" },

    config = {
        package_root = vim.fn.stdpath("config") .. "/site/pack",
    },
})
