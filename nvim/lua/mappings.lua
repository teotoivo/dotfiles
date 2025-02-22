require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })

-- Ensure the mapping only applies to Nvim-Tree buffers using an autocmd
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "NvimTree_*", -- Match Nvim-Tree buffers
  callback = function()
    -- Map 'l' to open files in Nvim-Tree
    vim.api.nvim_set_keymap(
      "n",
      "l",
      ':lua require"nvim-tree.api".node.open.edit()<CR>',
      { noremap = true, silent = true }
    )
  end,
})

map("n", "<leader>?", require("telescope.builtin").keymaps, { desc = "Find Keymaps" })

-- Ensure the mapping is removed when leaving an Nvim-Tree buffer
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "NvimTree_*",
  callback = function()
    -- Remove the custom mapping for 'l'
    vim.api.nvim_del_keymap("n", "l")
  end,
})
local dap, dapui = require "dap", require "dapui"
map("n", "<F5>", function()
  dap.continue()
end, { desc = "Start or continue debugging session" })

map("n", "<F9>", function()
  dap.step_over()
end, { desc = "Step over the current line" })

map("n", "<F10>", function()
  dap.step_into()
end, { desc = "Step into the current function" })

map("n", "<F12>", function()
  dap.step_out()
end, { desc = "Step out of the current function" })

map("n", "<Leader>b", function()
  dap.toggle_breakpoint()
end, { desc = "Toggle a breakpoint at the current line" })

map("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Set a conditional breakpoint" })

map("n", "<Leader>dr", function()
  dap.repl.open()
end, { desc = "Open the debug console (REPL)" })

map("n", "<Leader>dd", function()
  dap.terminate()
  dapui.close()
end, { desc = "Terminate the debugging session and close UI" })

map({ "t", "n" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts)
map({ "t", "n" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts)
map({ "t", "n" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts)
map({ "t", "n" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts)
map({ "t", "n" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", opts)
