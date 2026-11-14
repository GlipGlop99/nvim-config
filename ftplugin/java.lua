local jdtls = require 'jdtls'

local root_dir = vim.fs.root(0, '.bemol') or vim.fs.root(0, { 'gradlew', 'mvnw', 'settings.gradle', 'settings.gradle.kts', 'pom.xml', 'build.gradle', '.git' })
if not root_dir then return end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls/workspace/' .. project_name
local lombok = vim.fn.stdpath 'data' .. '/mason/share/jdtls/lombok.jar'

local cmd = { 'jdtls', '--jvm-arg=-Xmx2g', '--jvm-arg=-javaagent:' .. lombok, '-data', workspace_dir }

if vim.fn.executable '/usr/libexec/java_home' == 1 then
  local result = vim.system({ '/usr/libexec/java_home', '-v', '25' }):wait()
  if result.code == 0 then table.insert(cmd, 2, '--java-executable=' .. vim.trim(result.stdout) .. '/bin/java') end
end

local function bemol()
  local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
  if not bemol_dir then return end

  local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
  if not file then return end

  local ws_folders = {}
  for line in file:lines() do
    table.insert(ws_folders, line)
  end
  file:close()

  local current_folders = vim.lsp.buf.list_workspace_folders()
  for _, folder in ipairs(ws_folders) do
    if not vim.tbl_contains(current_folders, folder) then vim.lsp.buf.add_workspace_folder(folder) end
  end
end

jdtls.start_or_attach {
  cmd = cmd,
  root_dir = root_dir,

  capabilities = require('blink.cmp').get_lsp_capabilities(),

  settings = {
    java = {
      references = {
        includeDecompiledSources = true,
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },

  on_attach = bemol,
}
