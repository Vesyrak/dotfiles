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
require("trouble").setup()
local u = require("null-ls.utils")
local log = require("null-ls.logger")

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

--- Color scheme
--require("onedark").setup({
--    style = "darker",
--})
--require("onedark").load()
vim.cmd("colorscheme everforest")

--todo
--vim.api.nvim_create_autocmd("LspAttach", {
--	desc = "LSP actions",
--	callback = function(event)
--		-- Create your keybindings here...
--	end,
--})

local on_attach = function(client, bufnr)
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
        "jedi_language_server",
        "lua_ls",
        "rust_analyzer",
        "yamlls",
    },
    automatic_installation = true,
})
local lspconfig = require("lspconfig")
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
-- Non-default capabilities
require("lspconfig").jedi_language_server.setup({
    capabilities = lsp_capabilities,
    on_attach = on_attach,
    init_options = {
        diagnostics = { enable = false },
    },
    workspace = {
        extraPaths = {
            ".venv/lib/python3.9/site-packages",
            ".venv/lib/python3.10/site-packages",
            ".venv/lib/python3.11/site-packages",
            ".venv/lib/python3.12/site-packages",
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
            extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
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
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "rst",
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
    pickers = {
        buffers = {
            sort_mru = true,
        },
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

-- Lualine
-- require("lualine").setup({ options = { theme = "onedark", globalstatus = "true" } })
require("lualine").setup({ options = { theme = "everforest", globalstatus = "true" } })

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
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})

-- LLM
local llamacpp = require("llm.providers.llamacpp")

require("llm").setup({
    prompts = {
        llamacpp = {
            provider = llamacpp,
            params = {
                model = "/home/reinout/repos/llama.cpp/models/7B/ggml-model-f16.gguf",
                ["n-gpu-layers"] = 32,
                threads = 6,
                ["repeat-penalty"] = 1.2,
                temp = 0.2,
                ["ctx-size"] = 4096,
                ["n-predict"] = -1,
            },
            builder = function(input)
                return {
                    prompt = llamacpp.llama_2_format({
                        messages = {
                            input,
                        },
                    }),
                }
            end,
            options = {
                path = "/Users/reinout/repos/llama.cpp/",
                main_dir = "build/bin/Release/",
            },
        },
    },
})
