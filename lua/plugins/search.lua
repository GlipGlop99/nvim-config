vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }

local fzf = require 'fzf-lua'
fzf.setup { file_ignore_patterns = { 'build/', 'node_modules/' } }
fzf.register_ui_select()

vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sF', function() fzf.files { no_ignore = true } end, { desc = '[S]earch all [F]iles (no ignore)' })
vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('x', '<leader>sw', fzf.grep_visual, { desc = '[S]earch [W]ord selection' })
vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', function() fzf.live_grep { no_ignore = true, hidden = true } end, { desc = '[S]earch by [G]rep (no ignore)' })
vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>s/', fzf.lines, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>sn', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

vim.keymap.set('n', 'grr', fzf.lsp_references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gri', fzf.lsp_implementations, { desc = '[G]oto [I]mplementation' })
vim.keymap.set('n', 'grd', fzf.lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { desc = '[G]oto [T]ype Definition' })
vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { desc = 'Open Document Symbols' })
vim.keymap.set('n', 'gW', fzf.lsp_live_workspace_symbols, { desc = 'Open Workspace Symbols' })
