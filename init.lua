--[[

Based on kickstart.nvim from
https://github.com/nvim-lua/kickstart.nvim

--]]

-- nvim-tree requests netrw be disabled asap
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Indicates that the terminal is using a nerd font
-- Enables/disables some plugins and options within this config
vim.g.have_nerd_font = true

-- [[ Setting options ]]

-- Set highlight on search
vim.opt.hlsearch = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Every wrapped line will continue visually indented
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default, used by gitsigns
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
-- vim.opt.splitbelow = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', space = ' ' }

-- Show pending subsitutions in a small split window
vim.opt.inccommand = 'split'

-- Show which line the cursor is on
vim.opt.cursorline = true

-- Keep some space at top and bottom of screen
vim.opt.scrolloff = 8

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect,preview'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- Tab spacing
-- NOTE: vim-sleuth auto-detects settings and may override. See |sleuth|
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- [[ Clip board ]]
-- Immediately set clipboard on Windows, to not delay startup time
-- Taken from /usr/local/share/nvim/runtime/autoload/provider/clipboard.vim
local win32yank = vim.fn.exepath('win32yank.exe')
if win32yank and #win32yank > 0 then
  if vim.fn.has('wsl') and vim.fn.getftype(win32yank) == 'link' then
    win32yank = vim.fn.resolve(win32yank)
  end
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = { win32yank, '-i', '--crlf' },
      ['*'] = { win32yank, '-i', '--crlf' },
    },
    paste = {
      ['+'] = { win32yank, '-o', '--lf' },
      ['*'] = { win32yank, '-o', '--lf' },
    },
    cache_enabled = 1,
  }
end


-- [[ Basic Keymaps ]]

-- Remap for word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Use ctrl-/ to hide the search results after a search (e.g. from /).
-- Complementary to :hlsearch on
vim.keymap.set('n', '<C-_>', '<cmd>nohlsearch<CR>', { desc = 'Hide search results' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = 'Go to previous error message' })
vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = 'Go to next error message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>dh', (function()
  local show = true
  return function()
    show = not show
    if show then
      vim.diagnostic.enable()
      print("Diagnostics enabled")
    else
      vim.diagnostic.disable()
      print("Diagnostics disabled")
    end
  end
end)(), { desc = 'Toggle diagnostics on/off' })

-- Edit neovim init.lua from anywhere!
vim.keymap.set('n', '<leader>hi', ':e $MYVIMRC<cr>', { desc = 'Edit neovim config' })

-- 2x ESC to go to normal mode from :terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Normal mode from terminal' })

-- Center on next/prev when searching with / n N
vim.keymap.set('n', 'n', 'nzz', { desc = 'next search and center' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'prev search and center' })

-- visually select the last yanked or inserted text
vim.keymap.set('n', 'gy', "`[v`]", { desc = "Select last inserted or yanked text" })

-- Move lines up and down with Alt-j, Alt-k in normal and visual modes
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move lines down one' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move lines up one' })
vim.keymap.set('i', '<A-j>', '<Esc>m .+1<CR>==gi', { desc = 'Move lines down one' })
vim.keymap.set('i', '<A-k>', '<Esc>m .-2<CR>==gi', { desc = 'Move lines up one' })

-- Run vimscript
vim.cmd([[
" The marks do not appear to be set before the action in vim.keymap.set(), so leave them here
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv

hi eolSpace ctermbg=238 guibg=#CCCCCC
match eolSpace /\s\+$/
]])

-- Training wheels
local function training_wheels() print("No arrow keys!") end
vim.keymap.set('n', '<Up>', training_wheels, { desc = "Training wheels" })
vim.keymap.set('n', '<Down>', training_wheels, { desc = "Training wheels" })
vim.keymap.set('n', '<Left>', training_wheels, { desc = "Training wheels" })
vim.keymap.set('n', '<Right>', training_wheels, { desc = "Training wheels" })

-- [[ Auto commands ]]
--  See `:help lua-guide-autocommands`

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- [[ Install `lazy.nvim` plugin manager ]]
--  :help lazy.nvim.txt or https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Surround [selection/motion] in quotes/<tags>, and delete surrounding ..
  -- add: ysiw"   delete:  ds"    change:  cs"'
  { "kylechui/nvim-surround", opts = {} },

  -- Jump to last position when re-opening file
  { 'ethanholz/nvim-lastplace', opts = {} },

  -- Navigate between tmux panes with ctrl-h/j/k/l
  'christoomey/vim-tmux-navigator',

  -- Colour scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-latte'
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            height = 9999, -- use maximum height
            width = 0.85,
            horizontal = {
              preview_cutoff = 100,
              prompt_position = "bottom",
            },
            vertical = {
              preview_cutoff = 40,
              prompt_position = "bottom",
            },
            flex = {
              flip_columns = 120,
            },
          },
          use_less = false,
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find({
          winblend = 10,
          layout_config = { height = 0.8 },
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gt', builtin.git_status, { desc = 'Telescope: git status' })
      vim.keymap.set('n', '<leader>gB', builtin.git_branches, { desc = 'Telescope: git branches' })


      vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [T]elescope' })
      vim.keymap.set('n', '<leader>si', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch neovim configuration' })
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = { 'searchcount', 'filesize', 'encoding', 'fileformat', 'filetype' },
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    }
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup()

          vim.keymap.set('n', '<leader>ce', '<cmd>TSContextEnable<CR>', { desc = 'Function context enable' })
          vim.keymap.set('n', '<leader>cd', '<cmd>TSContextDisable<CR>', { desc = 'Function context disable' })
          vim.keymap.set('n', '<leader>cc', '<cmd>TSContextToggle<CR>', { desc = 'Function context toggle' })

          vim.cmd([[
          hi TreesitterContext guibg=#dde0dd
          hi TreesitterContextLineNumberBottom gui=underline
          ]])
        end,
      }
    },
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      modules = {},
      sync_install = false,
      ignore_install = {},

      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'bash', 'html', 'markdown' },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,

      highlight = { enable = true },
      indent = { enable = true, disable = { 'c', 'cpp' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<C-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@call.outer',
            ['ic'] = '@call.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['in'] = '@number.inner',
            ['an'] = '@number.inner', -- There is no number.outer
            ['ib'] = '@block.inner',
            ['ab'] = '@block.outer',
            ['ir'] = '@return.inner',
            ['ar'] = '@return.outer',
            ['iv'] = '@conditional.inner',
            ['av'] = '@conditional.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']a'] = '@parameter.inner',
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
            [']l'] = '@loop.outer',
            [']b'] = '@block.outer',
            [']r'] = '@return.outer',
            [']n'] = '@number.inner',
            [']v'] = '@conditional.inner',
          },
          goto_next_end = {
            [']A'] = '@parameter.outer',
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
            [']L'] = '@loop.outer',
            [']B'] = '@block.outer',
            [']R'] = '@return.outer',
            [']N'] = '@number.inner',
            [']V'] = '@conditional.inner',
          },
          goto_previous_start = {
            ['[a'] = '@parameter.inner',
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
            ['[l'] = '@loop.outer',
            ['[b'] = '@block.outer',
            ['[r'] = '@return.outer',
            ['[n'] = '@number.inner',
            ['[v'] = '@conditional.outer',
          },
          goto_previous_end = {
            ['[A'] = '@parameter.outer',
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
            ['[L'] = '@loop.outer',
            ['[B'] = '@block.outer',
            ['[R'] = '@return.outer',
            ['[N'] = '@number.inner',
            ['[V'] = '@conditional.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration for neovim functions
      'folke/neodev.nvim',
    },
    config = function()
      -- Setup neovim lua configuration
      require('neodev').setup()

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          local tele = require('telescope.builtin')
          nmap('gd', tele.lsp_definitions, '[G]oto [D]efinition')
          nmap('gr', tele.lsp_references, '[G]oto [R]eferences')
          nmap('gI', tele.lsp_implementations, '[G]oto [I]mplementation')
          nmap('<leader>D', tele.lsp_type_definitions, 'Type [D]efinition')
          nmap('<leader>ds', tele.lsp_document_symbols, '[D]ocument [S]ymbols')
          nmap('<leader>ws', tele.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- See `:help K` for why this keymap
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
          vim.keymap.set('i', '<C-S-k>', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })

          -- Lesser used LSP functionality
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          filetypes = {
            "c", "cpp", "objc", "objcpp", "cuda"
          },
        },
        -- gopls = {},
        pylsp = {
          -- TODO: probably need this in a sub-table called `settings`
          pylsp = {
            plugins = {
              pycodestyle = {
                -- ignore = {'W391'},
                maxLineLength = 200,
              },
            },
          },
        },
        -- rust_analyzer = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },

        -- lua_ls = {
        --   Lua = {
        --     workspace = { checkThirdParty = false },
        --     telemetry = { enable = false },
        --   },
        -- },

        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }


      require('mason').setup()


      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        'stylua', -- Format lua code
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      local on_attach = function(_, bufnr)
        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = require('lspconfig')[server_name]
            if server and server.setup then
              local settings = servers[server_name] or {}
              settings.capabilities = vim.tbl_deep_extend('force', {}, capabilities, settings.capabilities or {})
              settings.on_attach = settings.on_attach or on_attach
              require('lspconfig')[server_name].setup(settings)
            else
              print("Unhandled server " .. server_name)
            end
          end,
        },
      })
    end
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local next_snippet_node = function(fallback)
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end

      local prev_snippet_node = function(fallback)
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-y>'] = cmp.mapping.confirm {
            select = true,
          },
          ['<C-l>'] = cmp.mapping(next_snippet_node, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(prev_snippet_node, { 'i', 's' }),
          -- ['<Tab>'] = cmp.mapping(next_snippet_node, { 'i', 's' }),
          -- ['<S-Tab>'] = cmp.mapping(prev_snippet_node, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
    end,
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup()
      require('which-key').register {
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '×' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      -- diff_opts = {
      --   algorithm = 'minimal',
      --   linematch = 60,
      -- },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function get_selected_line_range()
          return { vim.fn.line("v"), vim.fn.line(".") }
        end
        local function stage_selected()
          gs.stage_hunk(get_selected_line_range())
        end
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage git hunk' })
        vim.keymap.set('v', '<leader>gs', stage_selected, { desc = 'Stage git hunk in selection' })
        vim.keymap.set('n', '<leader>gS', gs.undo_stage_hunk, { desc = 'Undo stage git hunk' })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = 'Reset git hunk' })
        vim.keymap.set('n', '<leader>gA', gs.stage_buffer, { buffer = bufnr, desc = 'Stage file' })
        vim.keymap.set('n', '<leader>gU', gs.reset_buffer_index, { buffer = bufnr, desc = 'Unstage file' })
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { buffer = bufnr, desc = 'Reset file' })
        vim.keymap.set('n', '<leader>gd', gs.toggle_deleted, { buffer = bufnr, desc = 'Toggle showing deleted content' })
        vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame,
          { buffer = bufnr, desc = 'Toggle git blame current line' })
        vim.keymap.set('n', '<leader>gl', gs.toggle_linehl, { buffer = bufnr, desc = 'Toggle line highlight' })
        vim.keymap.set('n', '<leader>gw', gs.toggle_word_diff, { buffer = bufnr, desc = 'Toggle word diff' })
        vim.keymap.set('n', '<leader>gv', gs.select_hunk, { buffer = bufnr, desc = 'Select git hunk' })

        -- don't override the built-in and fugitive keymaps
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  -- Vim practice with :VimBeGood
  'ThePrimeagen/vim-be-good',

  -- Jump to earlier files
  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {
      menu = {
        width = 100,
      }
    },
    config = function()
      vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = 'Harpoon: [a]dd file' })
      vim.keymap.set('n', '<leader>hs', require('harpoon.ui').toggle_quick_menu, { desc = 'Harpoon: [s]how UI' })
      vim.keymap.set('n', '<leader>hj', require('harpoon.ui').nav_next, { desc = 'Harpoon: next mark' })
      vim.keymap.set('n', '<leader>hk', require('harpoon.ui').nav_prev, { desc = 'Harpoon: prev mark' })
      vim.keymap.set('n', '<leader>hq', function() require('harpoon.ui').nav_file(1) end, { desc = 'Harpoon: file 1' })
      vim.keymap.set('n', '<leader>hw', function() require('harpoon.ui').nav_file(2) end, { desc = 'Harpoon: file 2' })
      vim.keymap.set('n', '<leader>he', function() require('harpoon.ui').nav_file(3) end, { desc = 'Harpoon: file 3' })
      vim.keymap.set('n', '<leader>hr', function() require('harpoon.ui').nav_file(4) end, { desc = 'Harpoon: file 4' })
    end,
  },

  -- Welcome screen
  {
    'goolord/alpha-nvim',
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },

  -- D2 text-to-diagram support
  { 'terrastruct/d2-vim' },

  -- Rewrite with sudo
  {
    'lambdalisue/suda.vim',
    event = 'VeryLazy',
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- File browser
  {
    'nvim-tree/nvim-tree.lua',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    opts = {
      view = {
        side = "right",
        width = 43,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      vim.keymap.set('n', '-', function()
        require("nvim-tree.api").tree.toggle({ path = ".", find_file = true, update_root = true, focus = true })
      end, { desc = 'Toggle nvim-tree view' })
    end,
  },

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
