require "nvchad.options"

-- add yours here!

local o = vim.o

o.number = true
o.relativenumber = true

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
