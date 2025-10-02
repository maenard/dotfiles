vim.opt.guicursor = "n-v-i-c:block-Cursor"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.list = false
vim.g.indent_blankline_enabled = false

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false

vim.g.format_modifications_only = true
