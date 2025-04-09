local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local dap = require("dap")

-- DAP mappings with proper options and descriptions
map("n", "<F5>", dap.continue, { desc = "DAP: Continue", noremap = true, silent = true })
map("n", "<F9>", dap.step_over, { desc = "DAP: Step Over", noremap = true, silent = true })
map("n", "<F10>", dap.step_into, { desc = "DAP: Step Into", noremap = true, silent = true })
map("n", "<F11>", dap.step_out, { desc = "DAP: Step Out", noremap = true, silent = true })

-- Toggle Terminal (works in all modes)
map({ "n", "i", "v", "t" }, "<A-h>", function()
  Snacks.terminal() -- make sure this function exists in your runtime
end, { desc = "Toggle Terminal", noremap = true, silent = true })

-- Buffer navigation
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Scroll up/down and center the cursor
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center", noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center", noremap = true, silent = true })
