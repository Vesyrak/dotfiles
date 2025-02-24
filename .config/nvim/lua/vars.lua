--[[ vars.lua ]]

local g = vim.g
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

-- Copy to clipboard
vim.cmd("set clipboard=unnamedplus")

g.editorconfig = true

-- Colors
g.t_co = 256
g.background = "dark"
-- Blamer
g.blamer_delay = 300

-- Color-scheme
g.edge_style = "aura"
g.edge_better_performance = 1

local md_augroup = ag("Markdown Settings", { clear = true })
au({ "BufWritePre" }, {
    pattern = { "*.md", "*.rst" },
    group = md_augroup,
    command = "setlocal textwidth=80 wrap",
})

---Highlight yanked text
au("TextYankPost", {
    group = ag("yank_highlight", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})

g.nonels_supress_issue58 = true

-- Format on write
local fmt_augroup = vim.api.nvim_create_augroup("AutoFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = fmt_augroup,
    callback = function()
        vim.lsp.buf.format({ async = true })
    end,
})

-- Restore cursor
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})
