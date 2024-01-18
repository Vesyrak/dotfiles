-- Simple setups
--require("bufferline").setup()
require("gitsigns").setup()
require("luasnip").setup()
require("luasnip.loaders.from_vscode").lazy_load()
-- require("nvim-autopairs").setup()
require("nvim-surround").setup()
require("oil").setup()
require("refactoring").setup()
--require("scope").setup()
require("todo-comments").setup({
    highlight = {
        --        pattern = "[[\b(KEYWORDS)[[:alpha:]]*:]]", -- ripgrep regex
        --
    },
})
require("trouble").setup()
local u = require("null-ls.utils")
local log = require("null-ls.logger")

require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
require("dapui").setup()
-- Illuminate
require("illuminate").configure({
    delay = 50,
})

-- Testing
require("neotest").setup({
    adapters = {
        require("neotest-plenary"),
        require("neotest-python")({ args = { "--disable-warnings" } }),
    },
})
require("neodev").setup({
    library = { plugins = { "neotest" }, types = true },
    setup_jsonls = false,
    lspconfig = false,
})

-- Start Screen
require("alpha").setup(require("alpha.themes.dashboard").config)

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

-- LSP signature
require("lsp_signature").setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
        border = "rounded",
    },
})

-- NVIM Tree
require("nvim-tree").setup({
    modified = { enable = true },
    disable_netrw = false,
    hijack_netrw = true,
    filters = { git_ignored = false },
})

-- Debugpy
local default_config = { justMyCode = false }

require("debugpy").run = function(config)
    local final = vim.tbl_extend("keep", config, default_config)
    require("dap").run(final)
end

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
-- Mason/cmp
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "jdtls",
        --"jedi_language_server",
        --"ruff_lsp",
        --"pylyzer",
        "pyright",
        "lua_ls",
        "rust_analyzer",
        "yamlls",
    },
    automatic_installation = true,
})
local lspconfig = require("lspconfig")
require("lspconfig").pyright.setup({})
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
    function(server_name)
        if server_name ~= "jedi_language_server" then
            lspconfig[server_name].setup({
                capabilities = lsp_capabilities,
            })
        end
    end,
})
require("lspconfig").pyright.setup({
    capabilities = lsp_capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            venvPath = ".venv/lib",
        },
    },
})

--autopairs
--local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- glow
require("glow").setup({
    width = 200,
    width_ratio = 0.9,
})

-- null_ls
local null_ls = require("null-ls")
null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.diagnostics.checkstyle.with({
            extra_args = { "-c", "/google_checks.xml" },
        }),
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.commitlint,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.mypy.with({}),
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.autoflake,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.google_java_format,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "css", "markdown" },
            disabled_filetypes = { "yaml" },
        }),
        null_ls.builtins.formatting.ocdc,
        null_ls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace,
    },
    on_attach = on_attach,
})

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
        "toml",
        "yaml",
    },
    auto_install = true,
    indent = {
        enable = true,
    },
    highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
})

require("telescope.actions")
require("telescope").setup({
    defaults = {
        pickers = {
            buffers = {
                sort_mru = true,
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
})
require("telescope").load_extension("aerial")
require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("refactoring")
require("telescope").load_extension("notify")

-- vim-notify
vim.notify = require("notify")

-- IndentLine
require("ibl").setup({ scope = { show_end = false } })

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

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        --{ name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})

-- LLM
local ollama = require("model.providers.ollama")
local mode = require("model").mode

require("model").setup({
    prompts = {
        code = {
            provider = ollama,
            params = {
                model = "stable-code",
            },
            builder = function(input)
                return {
                    prompt = input,
                }
            end,
        },
        codeimprove = {
            provider = ollama,
            params = {
                model = "stable-code",
            },
            builder = function(input)
                return {
                    prompt = "Improve the following code: " .. input,
                }
            end,
        },
        gitcommit = {
            provider = ollama,
            params = {
                model = "stable-code",
            },
            mode = mode.INSERT,
            builder = function()
                local git_diff = vim.fn.system({ "git", "diff", "--staged" })
                return {
                    prompt = "Write a short commit message according to the Conventional Commits specification for the following git diff: ```\n"
                        .. git_diff
                        .. "\n```",
                }
            end,
        },
    },
})
