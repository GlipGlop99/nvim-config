vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    kotlin = { 'ktlint' },
  },
  formatters = {
    ktlint = {
      extra_args = {
        '--editorconfig=' .. vim.fn.expand '~/.config/ktlint/.editorconfig',
      },
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
