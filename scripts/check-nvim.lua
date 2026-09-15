local registry = require('mason-registry')
local required = { 'html-lsp', 'json-lsp', 'pyright', 'lua-language-server',
  'stylua', 'prettier', 'prettierd', 'markdownlint', 'delve' }
local ok = vim.wait(120000, function()
  for _, name in ipairs(required) do
    if not registry.has_package(name) or not registry.get_package(name):is_installed() then return false end
  end
  return true
end, 200)
if not ok then
  vim.api.nvim_err_writeln('Neovim tools incomplete. Inspect :Mason and rerun the installer.')
  vim.cmd('cquit 1')
end
vim.cmd.colorscheme('neobrutalist')
require('lualine')
print('Neovim theme and required Mason tools verified.')
