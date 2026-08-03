return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'nvim-neotest/nvim-nio',
    {
      'rcarriga/nvim-dap-ui',
      init = function()
        require('dapui').setup()
        vim.env.dapui_tabpage_id = 10
        vim.env.dapui_prev_tabpage_id = 1
      end,
    },
  },

  config = function()
    local dap = require 'dap'

    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
    }
    dap.adapters.arm_none_eabi_gdb = {
      type = 'executable',
      command = 'arm-none-eabi-gdb',
      args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'gdb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = {}, -- provide arguments if needed
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
      },
    }

    dap.configurations.c = {
      {
        name = 'Launch',
        type = 'gdb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = {}, -- provide arguments if needed
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = 'Attach to arm-none-eabi-gdb server :1234',
        type = 'arm_none_eabi_gdb',
        request = 'attach',
        target = function()
          return vim.fn.input('Hostname of server: ', 'localhost') .. '4242'
        end,
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
      },
      --[[
      {
        name = 'Attach to gdbserver localhost:1234',
        type = 'gdb',
        request = 'attach',
        target = 'localhost:1234',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
      },
      {
        name = 'Select and attach to process',
        type = 'gdb',
        request = 'attach',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        pid = function()
          local name = vim.fn.input 'Executable name (filter): '
          return require('dap.utils').pick_process { filter = name }
        end,
        cwd = '${workspaceFolder}',
      },
	  --]]
    }
  end,
}
