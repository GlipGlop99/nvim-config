vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if ev.data.spec.name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
}

local ts = require 'nvim-treesitter'
ts.install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'typst', 'vim', 'vimdoc' }

---@param buf integer
---@param lang string
local function attach(buf, lang)
  vim.treesitter.start(buf, lang)
  if vim.treesitter.query.get(lang, 'indents') then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available = ts.get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end

    if vim.treesitter.language.add(lang) then
      attach(args.buf, lang)
    elseif vim.tbl_contains(available, lang) then
      ts.install(lang):await(function() attach(args.buf, lang) end)
    end
  end,
})

require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
    selection_modes = {
      ['@function.outer'] = 'V',
    },
  },
}

vim.keymap.set(
  { 'v', 'o' },
  'af',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
  { desc = 'Select around function' }
)
vim.keymap.set(
  { 'v', 'o' },
  'if',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
  { desc = 'Select inside function' }
)

vim.keymap.set('n', '<A-S-j>', function() require('nvim-treesitter-textobjects.swap').swap_next '@function.outer' end, { desc = 'Swap function with next' })
vim.keymap.set(
  'n',
  '<A-S-k>',
  function() require('nvim-treesitter-textobjects.swap').swap_previous '@function.outer' end,
  { desc = 'Swap function with previous' }
)
