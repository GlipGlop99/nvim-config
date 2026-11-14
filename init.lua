do
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
end

do
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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

  vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
  vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', { desc = 'Close buffer' })
  vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMoveNext<CR>', { desc = '[B]uffer move right' })
  vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineMovePrev<CR>', { desc = '[B]uffer move left' })
  vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', { desc = '[B]uffer [P]in toggle' })
  vim.keymap.set('n', '<leader>bf', '<cmd>BufferLinePick<CR>', { desc = '[B]uffer [F]ind (pick)' })

  vim.keymap.set('n', '<leader>T', '<cmd>split | terminal<CR>', { desc = 'Open [T]erminal below' })
  vim.keymap.set('n', '<leader>V', '<cmd>vsplit | terminal<CR>', { desc = 'Open terminal [V]ertical right' })

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
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
end

do
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
end

local function gh(repo) return 'https://github.com/' .. repo end

do
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  vim.pack.add { gh 'folke/which-key.nvim' }
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

  vim.pack.add { gh 'catppuccin/nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('catppuccin').setup { no_italic = true }
  vim.cmd.colorscheme 'catppuccin-mocha'

  vim.pack.add { gh 'stevearc/oil.nvim' }
  require('oil').setup {}
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()

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

  vim.pack.add { gh 'nvim-lualine/lualine.nvim' }
  vim.pack.add { gh 'akinsho/bufferline.nvim' }

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
end

do
  vim.pack.add { gh 'ibhagwan/fzf-lua' }

  local fzf = require 'fzf-lua'
  fzf.setup { file_ignore_patterns = { 'build/', 'node_modules/' } }
  fzf.register_ui_select()

  vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sF', function() fzf.files { no_ignore = true } end, { desc = '[S]earch all [F]iles (no ignore)' })
  vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sG', function() fzf.live_grep { no_ignore = true, hidden = true } end, { desc = '[S]earch by [G]rep (no ignore)' })
  vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })

  vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
  vim.keymap.set(
    'n',
    '<leader>s/',
    function() fzf.live_grep { grep_open_files = true, prompt = 'Live Grep in Open Files> ' } end,
    { desc = '[S]earch [/] in Open Files' }
  )
  vim.keymap.set('n', '<leader>sn', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('fzf-lua-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', fzf.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', 'gW', fzf.lsp_live_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
      vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })
end

do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {
    progress = {
      suppress_on_insert = true,
      poll_rate = 0.5,
      ignore_done_already = true,
      ignore_empty_message = true,
      display = {
        done_ttl = 0.5,
      },
    },
    notification = {
      window = {
        winblend = 0,
        border = 'rounded',
      },
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),

    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.util.buf_clear_references(event2.buf)
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  ---@type table<string, vim.lsp.Config>
  local servers = {
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.list_extend(vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
    },

    kotlin_lsp = {},

    tinymist = {
      root_markers = { 'typst.toml', '.git' },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
    gh 'mfussenegger/nvim-jdtls',
  }

  require('mason').setup {}

  require('mason-tool-installer').setup {
    ensure_installed = {
      'lua-language-server',
      { 'kotlin-lsp', auto_update = true },
      'jdtls',
      'stylua',
      'ktlint',
      'markdownlint-cli2',
    },
  }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

do
  vim.pack.add { gh 'stevearc/conform.nvim' }
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
end

do
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },
    signature = { enabled = true },
  }
end

do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }
  vim.pack.add { gh 'nvim-treesitter/nvim-treesitter-textobjects' }

  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'typst', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)

    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    if has_indent_query then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        treesitter_try_attach(buf, language)
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
end

do
  require 'plugins.indent_line'
  require 'plugins.lint'
  require 'plugins.gitsigns'
end
