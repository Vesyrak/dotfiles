require("snacks").setup({
    bigfile = { enabled = true },
    debug = { enabled = true },
    dim = { enabled = true },
    indent = { enabled = true },
    notifier = { enabled = true },
    scratch = { enabled = true },
})

-- Simple setups
--require("bufferline").setup()
require("bqf").setup()
require("dapui").setup()
require("gitsigns").setup()
require("grug-far").setup()
require("headlines").setup()
-- require("nvim-autopairs").setup()
require("nvim-surround").setup()
require("refactoring").setup()
--require("scope").setup()
require("trouble").setup()

local u = require("null-ls.utils")
local log = require("null-ls.logger")

-- Illuminate
require("illuminate").configure({
    delay = 50,
})

require("zen-mode").setup({
    window = {
        width = 100,
    },
    plugins = {
        kitty = {
            enabled = true,
            font = "+4", -- font size increment
        },
    },
})
--
-- Testing
-- THis breaks codecompanion
--require("neotest").setup({
--    adapters = {
--        require("neotest-plenary"),
--        require("neotest-python")({ args = { "--disable-warnings" } }),
--    },
--})
--require("neodev").setup({
--    library = { plugins = { "neotest" }, types = true },
--    setup_jsonls = false,
--    lspconfig = false,
--})

-- wilder
local wilder = require("wilder")
wilder.setup({ modes = { ":", "/", "?" } })
wilder.set_option(
    "renderer",
    wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        highlighter = wilder.basic_highlighter(),
        left = { " ", wilder.popupmenu_devicons() },
        right = { " ", wilder.popupmenu_scrollbar() },
        highlights = {
            border = "Normal", -- highlight to use for the border
        },
        border = "rounded",
    }))
)

-- NVIM Tree
require("nvim-tree").setup({
    modified = { enable = true },
    disable_netrw = false,
    hijack_netrw = true,
    filters = { git_ignored = false },
})

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.g.SuperTabDefaultCompletionType = "context"
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end
--Aerial
local aerial = require("aerial")
aerial.setup({
    --	close_automatic_events = { "unfocus" },
    keymaps = {
        ["<CR>"] = {
            callback = function()
                local is_floating = vim.api.nvim_win_get_config(0).zindex ~= nil
                aerial.select()
                if is_floating then
                    aerial.close()
                end
            end,
        },
    },
})

-- Marks
require("marks").setup()

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "basedpyright",
        "bashls",
        "docker_compose_language_service",
        "dockerls",
        "jdtls",
        "jedi_language_server",
        "lua_ls",
        "marksman",
        "ruff",
        "rust_analyzer",
        "yamlls",
    },
    automatic_installation = true,
})

-- Autocomplete
require("blink.cmp").setup({
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    appearance = {
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    --completion.menu.draw = {
    --    treesitter = { 'lsp' }
    --},

    keymap = {
        preset = "default",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-space>"] = {
            function(cmp)
                cmp.show({ providers = { "snippets" } })
            end,
        },
        ["<CR>"] = { "select_and_accept", "fallback" },
    },

    signature = { enabled = true },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        cmdline = {},
        default = { "lsp", "path", "snippets", "buffer" }, --, "codecompanion"
        ---providers = {
        ---    codecompanion = {
        ---        name = "CodeCompanion",
        ---        module = "codecompanion.providers.completion.blink",
        ---    },
        ---},
    },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
local lspconfig = require("lspconfig")

-- LSP

lspconfig["basedpyright"].setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.semanticTokensProvider = nil
    end,
    capabilities = capabilities,
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
            },
        },
    },
})
lspconfig["ruff"].setup({
    capabilities = capabilities,
})

-- null_ls
local null_ls = require("null-ls")
null_ls.setup({
    debug = true,
    sources = {
        --    null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.diagnostics.checkstyle.with({
            extra_args = { "-c", "/google_checks.xml" },
        }),
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.commitlint,
        --null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.mypy.with({}),
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.google_java_format,
        --        null_ls.builtins.formatting.fixjson,
        --       null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "css" },
            disabled_filetypes = { "markdown", "yaml" },
        }),
        null_ls.builtins.formatting.ocdc,
        null_ls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
        null_ls.builtins.formatting.terraform_fmt,
        --null_ls.builtins.formatting.trim_newlines,
    },
    on_attach = on_attach,
})

require("editorconfig").trim_trailing_whitespace = true

-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "comment",
        "css",
        "diff",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "hcl",
        "html",
        "ini",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "rst",
        "rust",
        "terraform",
        "toml",
        "yaml",
    },
    auto_install = true,
    indent = {
        enable = true,
    },
    highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
    incremental_selection = {
        enable = true,
        keymaps = { --TODO Move to which-key?
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
                ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

                ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                ["<leader>nm"] = "@function.outer", -- swap function with next
            },
            swap_previous = {
                ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
                ["<leader>pm"] = "@function.outer", -- swap function with previous
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
                ["]c"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
                ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
                ["]C"] = { query = "@class.outer", desc = "Next class end" },
            },
            goto_previous_start = {
                ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
                ["[c"] = { query = "@class.outer", desc = "Prev class start" },
            },
            goto_previous_end = {
                ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
                ["[C"] = { query = "@class.outer", desc = "Prev class end" },
            },
        },
    },
})

require("telescope.actions")
require("telescope").setup({
    defaults = {
        pickers = {
            buffers = {
                sort_lru = true,
            },
        },
        file_ignore_patterns = { ".git/", ".cache", "build/", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },

        layout_config = {
            horizontal = {
                prompt_position = "bottom",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.85,
            height = 0.92,
            preview_cutoff = 120,
        },
        prompt_prefix = "  ",
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({
                -- even more opts
            }),

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
        },
    },
})
require("telescope").load_extension("aerial")
--require("telescope").load_extension("frecency")
require("telescope").load_extension("fzf")
require("telescope").load_extension("refactoring")
require("telescope").load_extension("ui-select")

require("todo-comments").setup({
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
})

require("fzf-lua").setup({ fzf_opts = { ["--layout"] = "default", ["--cycle"] = true } })
---- IndentLine
--require("ibl").setup({ scope = { show_end = false } })

-- Color Scheme
local color_scheme = os.getenv("COLOR_SCHEME")
if color_scheme == "green" then
    require("lualine").setup({ options = { theme = "everforest", globalstatus = "true" } })
    vim.cmd("colorscheme everforest")
elseif color_scheme == "purple" then
    require("lualine").setup({ options = { theme = "tokyonight-moon", globalstatus = "true" } })
    vim.cmd("colorscheme tokyonight-moon")
else
    require("lualine").setup({ options = { theme = "everforest", globalstatus = "true" } })
    vim.cmd("colorscheme everforest")
end

-- LLM
local adapter = {
    adapter = "ollama",
    model = "codellama:7b",
}

---require("codecompanion").setup({
---    display = {
---        diff = {
---            provider = "mini_diff",
---        },
---    },
---    strategies = {
---        chat = adapter,
---        inline = adapter,
---        agent = adapter,
---    },
---    log_level = "DEBUG",
---})
