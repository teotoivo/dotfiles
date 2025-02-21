return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Navigate left in tmux" } },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Navigate down in tmux" } },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Navigate up in tmux" } },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Navigate right in tmux" } },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "Navigate to previous tmux pane" } },
  },
}
