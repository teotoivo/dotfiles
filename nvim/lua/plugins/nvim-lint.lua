return {
  "mfussenegger/nvim-lint",
  lazy = false,
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      c = { "clang-tidy" },
      cpp = { "clang-tidy" },
      python = { "ruff" },
      lua = { "selene" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
