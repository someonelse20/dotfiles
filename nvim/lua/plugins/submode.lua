return {
  'pogyomo/submode.nvim',
  lazy = true,
  -- (recommended) specify version to prevent unexpected change.
  -- version = "6.0.0",

  config = function()
    local submode = require 'submode'

    submode.create('DebugMode', {
      mode = 'n',
      leave = '<ESC>',
      default = function(register)
        local dap = require 'dap'
        register('<down>', dap.step_over)
        register('<right>', dap.step_into)
        register('<left>', dap.step_out)
        register('<up>', dap.run_last)
        register('n', dap.step_over)
        register('s', dap.step_into)
        register('B', dap.step_out)
        register('r', dap.run_last)
        register('b', dap.toggle_breakpoint)
        register('c', dap.continue)
        register('c', dap.continue)
        --[[
        register('q', function()
          dap.disconnect()
          dap.close()
          vim.api.nvim_command 'DapuiToggle'
        end)
		]]
      end,
    })

    submode.create('LspOperator', {
      mode = 'n',
      -- enter = '<Space>l',
      leave = { 'q', '<ESC>' },
      default = function(register)
        register('d', vim.lsp.buf.definition)
        register('D', vim.lsp.buf.declaration)
        register('H', vim.lsp.buf.hover)
        register('i', vim.lsp.buf.implementation)
        register('r', vim.lsp.buf.references)
      end,
    })
  end,
}
