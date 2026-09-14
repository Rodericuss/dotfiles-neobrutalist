-- Match only this Neovim terminal's padding to its background.
local M = {}
function M.setup()
  if not vim.env.KITTY_LISTEN_ON or not vim.env.KITTY_WINDOW_ID or vim.fn.executable('kitten') == 0 then return end
  local original_bg
  local function remote(command, ...)
    local args = { 'kitten', '@', '--to', vim.env.KITTY_LISTEN_ON, command, '--match', 'id:' .. vim.env.KITTY_WINDOW_ID }
    vim.list_extend(args, { ... })
    return vim.system(args, { text = true }):wait(1000)
  end
  local function apply()
    if #vim.api.nvim_list_uis() == 0 then return end
    if not original_bg then
      local result = remote('get-colors')
      if result.code ~= 0 then return end
      original_bg = ('\n' .. result.stdout):match('\nbackground%s+(#[%x]+)')
      if not original_bg then return end
    end
    local bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg
    if bg then remote('set-colors', string.format('background=#%06x', bg)) end
    remote('set-spacing', 'padding=4')
  end
  local function restore()
    if not original_bg then return end
    remote('set-colors', 'background=' .. original_bg)
    remote('set-spacing', 'padding=default')
    original_bg = nil
  end
  local group = vim.api.nvim_create_augroup('NeobrutalistKitty', { clear = true })
  vim.api.nvim_create_autocmd({ 'VimEnter', 'UIEnter', 'ColorScheme', 'VimResume' }, { group = group, callback = apply })
  vim.api.nvim_create_autocmd({ 'VimLeavePre', 'VimSuspend' }, { group = group, callback = restore })
end
return M
