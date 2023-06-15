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

-- vim-notify
vim.notify = require("notify")
