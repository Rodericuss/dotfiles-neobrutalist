-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  -- TODO: AQUI IREI COLOCAR TODOS MEUS PLUGINS, EU ACHO:
  ----------------><----------------------------
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
      },
    },
  },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
  },
  { 'letorbi/vim-colors-modern-borland' },
  { 'nanotee/zoxide.vim' },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSNodeUnderCursor' },
  },
  -- {
  --   'nvimdev/dashboard-nvim',
  --   event = 'VimEnter',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   config = function()
  --     require('dashboard').setup {
  --       theme = 'doom',
  --       hide = {
  --         statusline = true,
  --         tabline = true,
  --         winbar = true,
  --       },
  --       config = {
  --         vertical_center = true,
  --         header = {
  --           '',
  --           ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  --           ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  --           ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  --           ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  --           ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  --           ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
  --           '',
  --           ' [ Arch Linux • Hyprland • Neovim ] ',
  --           '',
  --         },
  --         center = {
  --           {
  --             icon = '  ',
  --             icon_hl = 'DashboardIcon',
  --             desc = 'New File',
  --             desc_hl = 'DashboardDesc',
  --             key = 'n',
  --             key_hl = 'DashboardKey',
  --             key_format = ' [%s]',
  --             action = 'enew',
  --           },
  --           {
  --             icon = '  ',
  --             icon_hl = 'DashboardIcon',
  --             desc = 'Find File',
  --             desc_hl = 'DashboardDesc',
  --             key = 'f',
  --             key_hl = 'DashboardKey',
  --             key_format = ' [%s]',
  --             action = 'Telescope find_files',
  --           },
  --           {
  --             icon = '  ',
  --             icon_hl = 'DashboardIcon',
  --             desc = 'Live Grep',
  --             desc_hl = 'DashboardDesc',
  --             key = 'g',
  --             key_hl = 'DashboardKey',
  --             key_format = ' [%s]',
  --             action = 'Telescope live_grep',
  --           },
  --         },
  --         footer = function()
  --           local stats = require('lazy').stats()
  --           return {
  --             '',
  --             '⚡ ' .. stats.loaded .. '/' .. stats.count .. ' plugins loaded',
  --           }
  --         end,
  --       },
  --     }
  --
  --     vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#39ff14', bold = true })
  --     vim.api.nvim_set_hl(0, 'DashboardDesc', { fg = '#00ffff' })
  --     vim.api.nvim_set_hl(0, 'DashboardIcon', { fg = '#ff9900' })
  --     vim.api.nvim_set_hl(0, 'DashboardKey', { fg = '#ff0055', bold = true })
  --     vim.api.nvim_set_hl(0, 'DashboardShortCut', { fg = '#ff0055' })
  --     vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#555555', italic = true })
  --   end,
  -- },
  --> NOTE: lazygit stuff
  {
    'code-biscuits/nvim-biscuits',
    opts = { cursor_line_only = true },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>g', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  --> NOTE: tagbar stuff
  { 'preservim/tagbar' },
  --> NOTE: dropbar stuff
  -- { 'Bekaboo/dropbar.nvim' },
  --> NOTE: harpoon stuff
  { 'nvim-lua/plenary.nvim' },
  {
    'ThePrimeagen/harpoon',
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>mm', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = 'Go to Harpoon list' },
      { '<leader>M', "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = 'Add file to Harpoon' },
      { '<leader>mn', "<cmd>lua require('harpoon.ui').nav_next()  <cr>", desc = 'Go to next Harpoon file' },
      { '<leader>mp', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = 'Go to previous Harpoon file' },
      { '<leader>1', "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = 'Go to Harpoon[1]' },
      { '<leader>2', "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = 'Go to Harpoon[2]' },
      { '<leader>3', "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = 'Go to Harpoon[3]' },
      { '<leader>4', "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = 'Go to Harpoon[4]' },
      { '<leader>5', "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = 'Go to Harpoon[5]' },
    },
  },
  --> NOTE: mini stuff
  { 'echasnovski/mini.files', version = '*', opts = {} },
  { 'nvim-mini/mini.indentscope', version = false, opts = {} },
  { 'echasnovski/mini.icons', version = false },
  --> NOTE: flash stuff
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>n", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<leader>N", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "<leader>m", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "<leader>M", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },

  -- NOTE:  -->undotree <--
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>", desc = 'Go to [u]ndo tree' },
    },
  },
  -- NOTE:  -->hlslens <--
  { 'kevinhwang91/nvim-hlslens' },
  -- NOTE:  -->to make nvim transparent <--
  {
    'xiyaowong/transparent.nvim',
    enabled = false,
    opts = {

      -- Optional, you don't have to run setup.
      groups = { -- table: default groups
        'Normal',
        'NormalNC',
        'Comment',
        'Constant',
        'Special',
        'Identifier',
        'Statement',
        'PreProc',
        'Type',
        'Underlined',
        'Todo',
        'String',
        'Function',
        'Conditional',
        'Repeat',
        'Operator',
        'Structure',
        'LineNr',
        'NonText',
        'SignColumn',
        'CursorLine',
        'CursorLineNr',
        'StatusLine',
        'StatusLineNC',
        'EndOfBuffer',
      },
      extra_groups = {}, -- table: additional groups that should be cleared
      exclude_groups = {}, -- table: groups you don't want to clear
    },
  },
  -- NOTE: --> rose pine colorscheme<--
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      variant = 'auto', -- auto, main, moon, or dawn
      dark_variant = 'main', -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
      },

      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },

      groups = {
        border = 'muted',
        link = 'iris',
        panel = 'surface',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        note = 'pine',
        todo = 'rose',
        warn = 'gold',

        git_add = 'foam',
        git_change = 'rose',
        git_delete = 'love',
        git_dirty = 'rose',
        git_ignore = 'muted',
        git_merge = 'iris',
        git_rename = 'pine',
        git_stage = 'iris',
        git_text = 'rose',
        git_untracked = 'subtle',

        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
      },

      highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
      },

      before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
      end,
    },
  },
  -- { 'luisiacc/gruvbox-baby' },
  { 'EdenEast/nightfox.nvim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, but recommended
    },
    lazy = false,
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = '', -- or "" to use 'winborder' on Neovim v0.11+
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
      open_files_using_relative_paths = false,
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      sort_function = nil, -- use a custom function for sorting files and directories in the tree
      -- sort_function = function (a,b)
      --       if a.type == b.type then
      --           return a.path > b.path
      --       else
      --           return a.type > b.type
      --       end
      --   end , -- this sorts files and directories descendantly
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
            if node.type == 'file' or node.type == 'terminal' then
              local success, web_devicons = pcall(require, 'nvim-web-devicons')
              local name = node.type == 'terminal' and 'terminal' or node.name
              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = hl or icon.highlight
              end
            end
          end,
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = '*',
          highlight = 'NeoTreeFileIcon',
          use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            -- Change type
            added = '', -- or "✚"
            modified = '', -- or ""
            deleted = '✖', -- this can only be used in the git_status source
            renamed = '󰁕', -- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          width = 12, -- width of the column
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          width = 10, -- width of the column
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          width = 20, -- width of the column
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          width = 20, -- width of the column
          required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- see `:h neo-tree-custom-commands-global`
      commands = {},
      window = {
        position = 'right',
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = {
            'toggle_node',
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
          ['P'] = {
            'toggle_preview',
            config = {
              use_float = true,
              use_snacks_image = true,
              use_image_nvim = true,
            },
          },
          -- Read `# Preview Mode` for more information
          ['l'] = 'focus_preview',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          ['t'] = 'open_tabnew',
          -- ["<cr>"] = "open_drop",
          -- ["t"] = "open_tab_drop",
          ['w'] = 'open_with_window_picker',
          --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
          ['C'] = 'close_node',
          -- ['C'] = 'close_all_subnodes',
          ['z'] = 'close_all_nodes',
          --["Z"] = "expand_all_nodes",
          --["Z"] = "expand_all_subnodes",
          ['a'] = {
            'add',
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = 'none', -- "none", "relative", "absolute"
            },
          },
          ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['b'] = 'rename_basename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
          ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['i'] = 'show_file_details',
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_ignored = true, -- hide files that are ignored by other gitignore-like files
          -- other gitignore-like files, in descending order of precedence.
          ignore_files = {
            '.neotreeignore',
            '.ignore',
            -- ".rgignore"
          },
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          always_show_by_pattern = { -- uses glob style patterns
            --".env*",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = {
          enabled = false, -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
          mappings = {
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['H'] = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            ['D'] = 'fuzzy_finder_directory',
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
            -- ["D"] = "fuzzy_sorter_directory",
            ['f'] = 'filter_on_submit',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            ['o'] = {
              'show_help',
              nowait = false,
              config = { title = 'Order by', prefix_key = 'o' },
            },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['og'] = { 'order_by_git_status', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
            -- ['<key>'] = function(state) ... end,
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
            ['<esc>'] = 'close',
            ['<S-CR>'] = 'close_keep_filter',
            ['<C-CR>'] = 'close_clear_filter',
            ['<C-w>'] = { '<C-S-w>', raw = true },
            {
              -- normal mode mappings
              n = {
                ['j'] = 'move_cursor_down',
                ['k'] = 'move_cursor_up',
                ['<S-CR>'] = 'close_keep_filter',
                ['<C-CR>'] = 'close_clear_filter',
                ['<esc>'] = 'close',
              },
            },
            -- ["<esc>"] = "noop", -- if you want to use normal mode
            -- ["key"] = function(state, scroll_padding) ... end,
          },
        },

        commands = {}, -- Add a custom command or override a global one using the same function name
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          --              -- the current file is changed while the tree is open.
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
        window = {
          mappings = {
            ['d'] = 'buffer_delete',
            ['bd'] = 'buffer_delete',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['o'] = {
              'show_help',
              nowait = false,
              config = { title = 'Order by', prefix_key = 'o' },
            },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },
      git_status = {
        window = {
          position = 'float',
          mappings = {
            ['A'] = 'git_add_all',
            ['gu'] = 'git_unstage_file',
            ['gU'] = 'git_undo_last_commit',
            ['ga'] = 'git_add_file',
            ['gr'] = 'git_revert_file',
            ['gc'] = 'git_commit',
            ['gp'] = 'git_push',
            ['gg'] = 'git_commit_and_push',
            ['o'] = {
              'show_help',
              nowait = false,
              config = { title = 'Order by', prefix_key = 'o' },
            },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },
    },
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require('window-picker').setup()
    end,
  },
}
