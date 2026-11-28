vim.pack.add {
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
}

require('guess-indent').setup {}

require('oil').setup {}
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

require('mini.surround').setup()

require('mini.pairs').setup()

local function in_string()
  local ok, parser = pcall(vim.treesitter.get_parser)
  if not ok or not parser then return false end
  parser:parse(true)
  local node = vim.treesitter.get_node()
  return node ~= nil and node:type():find 'string' ~= nil
end

for key, info in pairs(MiniPairs.config.mappings) do
  if info and info.action ~= 'close' then
    vim.keymap.set('i', key, function()
      local line, col = vim.api.nvim_get_current_line(), vim.fn.col '.'
      local prev_char, next_char = line:sub(col - 1, col - 1), line:sub(col, col)
      local is_interpolation = key == '{' and prev_char == '$'
      if next_char ~= key and not is_interpolation and in_string() then return key end
      return MiniPairs[info.action](info.pair, info.neigh_pattern .. '[^%w]')
    end, { expr = true, replace_keycodes = false, desc = 'mini.pairs ' .. key })
  end
end

require('mini.hipatterns').setup {
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
  },
}

require('ibl').setup {}
