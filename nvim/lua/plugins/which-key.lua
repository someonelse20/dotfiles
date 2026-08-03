return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      spec = {
        -- Document existing key chains
        -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },

        -- CodeCompanion keybinds
        { '<leader>c', group = '[C]odeCompanion' },
        { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle [C]hat', group = '[C]odeCompanion' },

        -- Git keybinds
        { '<leader>g', group = '[G]it' },

        -- LSP keybinds
        {
          '<leader>l',
          function()
            local submode = require 'submode'
            submode.enter 'LspOperator'
          end,
          desc = 'Toggle [L]SP mode',
        },

        -- Debug keybinds
        { '<leader>d', group = '[D]ebug' },
        { '<leader>dt', '<cmd>DapuiToggle<cr>', desc = '[T]oggle debug UI' },
        {
          '<leader>dm',
          function()
            local submode = require 'submode'

            if submode.mode() == 'DebugMode' then
              submode.leave()
            else
              submode.enter 'DebugMode'
            end
          end,
          desc = 'Toggle debug [M]ode',
        },
      },
    },
  },
}
