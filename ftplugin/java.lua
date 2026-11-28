local root_dir = vim.fs.root(0, { 'gradlew', 'mvnw', 'settings.gradle', 'settings.gradle.kts', 'pom.xml', 'build.gradle', '.git' })
if not root_dir then return end

local cmd = {
  'jdtls',
  '--jvm-arg=-javaagent:' .. vim.fn.stdpath 'data' .. '/mason/share/jdtls/lombok.jar',
  '-data',
  vim.fn.stdpath 'cache' .. '/jdtls/workspace/' .. vim.fn.fnamemodify(root_dir, ':t'),
}

if vim.g.jdtls_java_home == nil and vim.fn.executable '/usr/libexec/java_home' == 1 then
  local result = vim.system({ '/usr/libexec/java_home', '-v', '25' }):wait()
  vim.g.jdtls_java_home = result.code == 0 and vim.trim(result.stdout) or ''
end
if vim.g.jdtls_java_home and vim.g.jdtls_java_home ~= '' then table.insert(cmd, 2, '--java-executable=' .. vim.g.jdtls_java_home .. '/bin/java') end

require('jdtls').start_or_attach {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
    },
  },
}
