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

    -- Big Files
    -- Completed: Mon 26 Feb, 2024
    { "LunarVim/bigfile.nvim" },

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
    -- Completed: Tue 27 Feb, 2024
    {
        "nvimtools/none-ls.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },

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
        opts = {
            highlight = {
                keyword = "bg",
                pattern = [[.*<(KEYWORDS)\s*]],
                max_line_len = 100,
            },
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            search = {
                pattern = [[ \b(KEYWORDS)\b]],
            },
        },
    },

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
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
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

    --- Useful macros ---
    --
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
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
    -- Completed: 2023-08-22 09:23
    {
        "folke/zen-mode.nvim",
        opts = {
            width = 80,
            kitty = {
                enabled = true,
                font = "+20", -- font size increment
            },
        },
    },
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

    -- Notifications
    -- Completed: Tue 27 Feb, 2024
    { "rcarriga/nvim-notify" },

    -- Indent lines
    -- Completed: Tue 27 Feb, 2024
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },

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
    {
        "kevinhwang91/nvim-bqf",
    },

    -- LLM
    {
        "David-Kunz/gen.nvim",
        opts = {
            model = "stable-code", -- The default model to use.
            display_mode = "float", -- The display mode. Can be "float" or "split".
            show_prompt = false, -- Shows the Prompt submitted to Ollama.
            show_model = false, -- Displays which model you are using at the beginning of your chat session.
            no_auto_close = false, -- Never closes the window automatically.
            init = function(options)
                pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
            end,
            -- Function to initialize Ollama
            command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
            -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
            -- This can also be a lua function returning a command string, with options as the input parameter.
            -- The executed command must return a JSON object with { response, context }
            -- (context property is optional).
            debug = false, -- Prints errors and the command which is run.
        },
    },

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

    -- Show markdown
    -- Completed: Mon 26 Feb, 2024
    { "ellisonleao/glow.nvim" },

    -- Undotree
    -- Completed: Mon 26 Feb, 2024
    { "mbbill/undotree" },

    config = {
        package_root = vim.fn.stdpath("config") .. "/site/pack",
    },
})
