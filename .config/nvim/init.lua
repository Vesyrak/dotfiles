---[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = " "

vim.g.localleader = "\\"

-- IMPORTS
require("vars") -- Variables
require("opts") -- Options
require("plug") -- Plugins
require("init_plug")
require("keys") -- Keymaps
