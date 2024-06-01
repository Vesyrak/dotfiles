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

-- Put /site in package path
local packer_path = vim.fn.stdpath("config") .. "/site"
vim.o.packpath = vim.o.packpath .. "," .. packer_path

-- vim-test
--g["test#strategy"] = "neovim"
--g["test#python#pytest#options"] = "--disable-warnings"

--" For documentation files, enable text wrapping and spell checking"
local md_augroup = ag("Markdown Settings", { clear = true })
au({ "BufWritePre" }, {
    pattern = { "*.md", "*.rst" },
    group = md_augroup,
    command = "setlocal textwidth=80 wrap",
})

local python_augroup = ag("Python Settings", { clear = true })
---Highlight yanked text
--
au("TextYankPost", {
    group = ag("yank_highlight", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
})
g.nonels_supress_issue58 = true
--vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
--    pattern = { "*.py" },
--    group = python_augroup,
--    command = "setlocal foldmethod=indent",
--})
--local trouble_augroup = vim.api.nvim_create_augroup("Trouble Settings", { clear = true })
--vim.api.nvim_create_autocmd("BufWritePost", {
--    pattern = { "*.py" },
--    group = trouble_augroup,
--    command = "Trouble",
--})
