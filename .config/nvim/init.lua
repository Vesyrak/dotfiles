---[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"

vim.g.mapleader = " "

vim.g.localleader = "\\"

require("vars")
if vim.fn.getfsize(vim.fn.expand("%")) < 1024 * 1024 then
    require("opts")
    require("plug")
    require("init_plug")
    require("keys")
end
