vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

vim.o.clipboard = 'unnamedplus'
vim.g.clipboard = 'osc52'

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.spell = true

vim.o.scrolloff = 10

vim.o.confirm = true

vim.o.autowriteall = true
vim.api.nvim_create_autocmd('FocusLost', {
  command = 'silent! wall',
})

vim.diagnostic.config {
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = false,
  virtual_lines = { current_line = true },

  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', { desc = 'Close buffer' })

vim.keymap.set('n', '<leader>T', '<cmd>split | terminal<CR>', { desc = 'Open [T]erminal below' })
vim.keymap.set('n', '<leader>V', '<cmd>vsplit | terminal<CR>', { desc = 'Open terminal [V]ertical right' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Disable spell in terminal',
  callback = function() vim.wo.spell = false end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Kill all terminal buffers on exit',
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_delete(buf, { force = true }) end
    end
  end,
})

require 'plugins.ui'
require 'plugins.editor'
require 'plugins.search'
require 'plugins.lsp'
require 'plugins.completion'
require 'plugins.format'
require 'plugins.lint'
require 'plugins.treesitter'
require 'plugins.git'
