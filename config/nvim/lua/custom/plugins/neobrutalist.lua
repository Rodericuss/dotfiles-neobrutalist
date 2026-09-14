return {
  -- Replace the old theme's init callback, including its hard-coded highlights.
  { 'folke/tokyonight.nvim', init = function() end },
  {
    'scottmckendry/cyberdream.nvim', lazy = false, priority = 1000,
    config = function()
      vim.cmd.colorscheme 'neobrutalist'
      require('neobrutalist.kitty').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'neobrutalist', globalstatus = true,
          component_separators = { left = '│', right = '│' },
          section_separators = { left = '▌', right = '▐' },
        },
        sections = {
          lualine_a = { 'mode' }, lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'encoding', 'filetype' }, lualine_y = { 'progress' }, lualine_z = { 'location' },
        },
        inactive_sections = { lualine_c = { 'filename' }, lualine_x = { 'location' } },
      }
    end,
  },
}
