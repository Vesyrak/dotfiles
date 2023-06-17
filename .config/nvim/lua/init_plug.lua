-- Simple setups
require("aerial").setup({ close_automatic_events = { "unfocus" } })
require("bufferline").setup()
require("gitsigns").setup()
require("luasnip").setup()
require("luasnip.loaders.from_vscode").lazy_load()
require("nvim-autopairs").setup()
require("nvim-surround").setup()
require("trouble").setup()

-- NVIM Tree
require("nvim-tree").setup({ modified = { enable = true } })

-- vim-notify
vim.notify = require("notify")

--- Color scheme
require("onedark").setup({
    style = "darker",
})
require("onedark").load()
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
-- Mason/cmp
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "lua_ls",
        "jedi_language_server",
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
        },
    },
})

--autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- glow
require("glow").setup({
    width = 200,
    width_ratio = 0.9,
})

-- null_ls
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.commitlint,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.formatting.autoflake,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.ocdc,
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "css", "markdown" },
            disabled_filetypes = { "yaml" },
        }),
        null_ls.builtins.formatting.stylua,
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
    highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
})

-- Telescope
require("telescope").setup({})
require("telescope").load_extension("aerial")
require("telescope").load_extension("vim_bookmarks")
-- require("telescope").load_extension("fzf") --Todo: Broken?

-- IndentLine
require("indent_blankline").setup({
    show_current_context = true,
    show_current_context_start = true,
})

require("telekasten").setup({
    home = vim.fn.expand("~/notes"),
    auto_set_filetype = false, -- TODO: adapt to true, and parse zettelkasten as markdown
})

-- Lualine
require("lualine").setup({ options = { theme = "onedark", globalstatus = "true" } })

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

-- TODO:
-- Set configuration for specific filetype.

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline({ "/", "?" }, {
--	mapping = cmp.mapping.preset.cmdline(),
--	sources = {
--		{ name = "buffer" },
--	},
--})
--
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline(":", {
--	mapping = cmp.mapping.preset.cmdline(),
--	sources = cmp.config.sources({
--		{ name = "path" },
--	}, {
--		{ name = "cmdline" },
--	}),
--})
