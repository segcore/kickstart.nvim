return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "jbyuki/one-small-step-for-vimkind", -- lua
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()

      require("nvim-dap-virtual-text").setup()

      vim.keymap.set("n", "<leader>dc", dap.run_to_cursor)
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint with condition' })

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>d<space>", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue, { desc = 'Debug: continue' })
      vim.keymap.set("n", "<F2>", dap.step_into, { desc = 'Debug: step into' })
      vim.keymap.set("n", "<F3>", dap.step_over, { desc = 'Debug: step over' })
      vim.keymap.set("n", "<F4>", dap.step_out, { desc = 'Debug: step out' })
      vim.keymap.set("n", "<F5>", dap.step_back, { desc = 'Debug: step back' })
      vim.keymap.set('n', '<F7>', ui.toggle, { desc = 'Debug: See last session result.' })
      vim.keymap.set("n", "<F8>", dap.restart, { desc = 'Debug: restart' })
      vim.keymap.set("n", "<F9>", dap.close, { desc = 'Debug: stop' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      --
      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
        },

        automatic_installation = false,
      }

      -- Language specific setups

      -- dap.adapters.codelldb = {
      --   type = 'server',
      --   host = '127.0.0.1',
      --   port = 13000, -- use that printed by --port
      -- }

      do -- Lua debugger
        vim.api.nvim_create_user_command('DebugLuaServerStart', function()
          require("osv").launch({port = 8086})
        end, {})
        vim.api.nvim_create_user_command('DebugLuaServerStop', function()
          require("osv").stop()
        end, {})
        vim.api.nvim_create_user_command('DebugLuaRunThis', function()
          require("osv").run_this()
        end, {})
        dap.configurations.lua = {
          {
            type = 'nlua',
            request = 'attach',
            name = "Attach to running Neovim instance",
          },
        }

        dap.adapters.nlua = function(callback, config)
          callback({type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086})
        end
      end
    end,
  },
}