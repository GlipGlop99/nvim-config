vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint-cli2' },
  kotlin = { 'ktlint' },
}

lint.linters.ktlint.args = {
  '--reporter=json',
  '--editorconfig=' .. vim.fn.expand '~/.config/ktlint/.editorconfig',
  '$FILENAME',
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
