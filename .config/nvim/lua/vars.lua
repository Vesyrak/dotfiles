--[[ vars.lua ]]

local g = vim.g

-- Copy to clipboard
vim.cmd("set clipboard=unnamedplus")

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
g["test#strategy"] = "neovim"
g["test#python#pytest#options"] = "--disable-warnings"

local md_augroup = vim.api.nvim_create_augroup("Markdown Settings", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.md" },
	group = md_augroup,
	command = "setlocal textwidth=80 wrap",
})

local python_augroup = vim.api.nvim_create_augroup("Python Settings", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
	pattern = { "*.py" },
	group = md_augroup,
	command = "setlocal foldmethod=indent",
})
