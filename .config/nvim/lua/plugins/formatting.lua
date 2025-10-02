return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    format = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      vue = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
  },
}
