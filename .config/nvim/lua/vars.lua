--[[ vars.lua ]]

local g = vim.g

-- NVim Tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Colors
g.t_co = 256
g.background = "dark"
-- Blamer
g.blamer_delay = 300

-- Put /site in package path
local packer_path = vim.fn.stdpath("config") .. "/site"
vim.o.packpath = vim.o.packpath .. "," .. packer_path

-- vim-test
g["test#strategy"] = "neovim"

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
