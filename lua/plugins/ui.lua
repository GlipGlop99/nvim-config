vim.pack.add {
  'https://github.com/catppuccin/nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/akinsho/bufferline.nvim',
}

---@diagnostic disable-next-line: missing-fields
require('catppuccin').setup { no_italic = true }
vim.cmd.colorscheme 'catppuccin-mocha'

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

require('which-key').setup {
  delay = 0,
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>b', group = '[B]uffer' },
    { 'gr', group = 'LSP Actions' },
  },
}

require('lualine').setup {
  options = {
    section_separators = '',
    component_separators = '|',
  },
  sections = {
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 2 } },
    lualine_x = { 'diagnostics', 'filetype' },
    lualine_y = {
      'encoding',
      function()
        if vim.bo.buftype == 'terminal' then return '' end
        if vim.bo.expandtab then
          return 'spaces:' .. vim.bo.shiftwidth
        else
          return 'tabs:' .. vim.bo.tabstop
        end
      end,
    },
  },
}

require('bufferline').setup {
  options = {
    max_name_length = 30,
    diagnostics = 'nvim_lsp',
    show_buffer_close_buttons = false,
    show_close_icon = false,
    name_formatter = function(buf)
      local full_name = vim.api.nvim_buf_get_name(buf.bufnr)
      if full_name:match '^jdt://' then
        local java_file = full_name:match '/([%w$]+%.java)'
        if java_file then return java_file end
      end
      return buf.name
    end,
  },
}

vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMoveNext<CR>', { desc = '[B]uffer move right' })
vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineMovePrev<CR>', { desc = '[B]uffer move left' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', { desc = '[B]uffer [P]in toggle' })
vim.keymap.set('n', '<leader>bf', '<cmd>BufferLinePick<CR>', { desc = '[B]uffer [F]ind (pick)' })
