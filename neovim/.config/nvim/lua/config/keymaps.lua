-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

local dap = require("dap")

map("n", "<F5>", dap.continue, "DAP: Continue")
map("n", "<F10>", dap.step_over, "DAP: Step Over")
map("n", "<F11>", dap.step_into, "DAP: Step Into")
map("n", "<F12>", dap.step_out, "DAP: Step Out")
